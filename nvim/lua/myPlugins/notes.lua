-- TODO: Paste image
-- TODO: Templates
-- TODO: Embed excalidraw
-- TODO: Obsidian daily note
-- TODO: Tags
-- TODO: Add notes to cmp, and their aliases
-- TODO: Floating diary
-- TODO: Add a function that convert obsidian style links to my new specaial type of links.
-- TODO: Auto format tables. Tab should move to the next column.

M = {}
M.opts = {
	-- notes_folder = vim.fn.expand("~/sync/knowledgeVault/"),
	notes_folder = vim.fn.expand("~/offline/notesTest"),
}

-- Check if the laod the required modules
local builtin_ok, builtin = pcall(require, "telescope.builtin")
local actions_ok, actions = pcall(require, "telescope.actions")
local action_state_ok, action_state = pcall(require, "telescope.actions.state")
local utils_ok, utils = pcall(require, "myPlugins.utils")
local scan_ok, scan = pcall(require, "plenary.scandir")

local function get_properties(note_path)
	-- note_path has to be relative path relative to notes_folder.
	local lines = vim.fn.readfile(note_path)
	local in_properties = false
	local properties_lines = {}
	for _, line in ipairs(lines) do
		if line:match("^%-%-%-$") then
			if in_properties then
				break -- Break at the end of the properties
			else
				in_properties = true -- start after opening ---
			end
		elseif in_properties then
			properties_lines[#properties_lines + 1] = line
		end
	end
	return properties_lines
end

local function get_aliases(note_path)
	-- note_path has to be relative path relative to notes_folder.
	local notes_properties = get_properties(note_path) -- Frontmatter of the file
	local file_name = vim.fn.fnamemodify(note_path, ":t:r")
	local aliases = { file_name }
	local in_aliases = false
	for _, line in ipairs(notes_properties) do
		if line:match("^aliases:") or line:match("^alias:") then
			in_aliases = true
		elseif in_aliases then
			local alias = line:match("^%s*%-%s*(.+)")
			if alias then
				table.insert(aliases, alias)
			elseif line:match("^%w+:") then
				-- next property starts, stop reading aliases
				in_aliases = false
			end
		end
	end
	return aliases
end

local function link_notes()
	local current_file_path = vim.api.nvim_buf_get_name(0)
	-- define a closure that captures current_file_path
	local function link_notes_2(prompt_bufnr, map)
		local function insert_link()
			local entry = action_state.get_selected_entry()
			local path = entry.path or entry.filename
			local name = vim.fn.fnamemodify(path, ":t:r")
			local aliases = get_aliases(path)

			actions.close(prompt_bufnr)

			local relative_file_path = utils.calculate_relative_path(current_file_path, path, { root_folder = M.opts.notes_folder })

			local function paste_link(link_name)
				local link = string.format("[%s](<%s>)", link_name, relative_file_path)
				vim.schedule(function()
					vim.api.nvim_put({ link }, "", true, true)
				end)
			end

			if #aliases > 1 then
				vim.ui.select(aliases, {
					prompt = "Select alias",
					format_item = function(alias)
						return alias
					end,
				}, function(choice)
					if choice then
						paste_link(choice)
					end
				end)
			else
				paste_link(name)
			end
		end

		map("i", "<CR>", insert_link)
		map("n", "<CR>", insert_link)
		return true
	end

	builtin.find_files({
		cwd = M.opts.notes_folder,
		prompt_title = "Link note",
		attach_mappings = link_notes_2,
	})
end

local function find_true_backlinks()
	-- Function that find all the backlinks to the current file.
	-- returns a dict where the key is the file path and the value is a list of all the links. A single link contains line, col, row.
	local current_note = vim.api.nvim_buf_get_name(0)
	local backlinks = {}
	local note_links = {}
	local file_contents

	local folder_notes = scan.scan_dir(M.opts.notes_folder, { depth = 10, search_pattern = "%.md$" })

	local pattern

	for _, note in ipairs(folder_notes) do
		note_links = {}
		if note ~= current_note then
			-- compute expected relative link from 'note' → 'current_note', to check if folder_note is actually pointing to current_note
			-- local rel = calculate_relative_file_path(other, current, notes_root)
			local rel = utils.calculate_relative_path(note, current_note, { root_folder = M.opts.notes_folder })

			if not rel then
				vim.notify("Could not calculate relative path", vim.log.levels.ERROR)
				return
			end

			file_contents = vim.fn.readfile(note)
			pattern = "%]%(%s*<?" .. vim.pesc(rel) .. "[^)]*>?%)"

			local content = table.concat(file_contents, "\n")
			if content:find("%]%(%s*" .. vim.pesc(rel) .. "[^)]*%)") then
				-- for line in file_contents do
				for linenr, line in ipairs(file_contents) do
					local start = 1

					while true do
						local s, e = line:find(pattern, start)
						if not s then
							break
						end

						table.insert(note_links, {
							linenr = linenr,
							col = s,
							text = line,
						})

						start = e + 1
					end
				end
			end

			-- -- check if that exact relative path string appears in the other file
			-- local content = table.concat(vim.fn.readfile(note), "\n")
			-- if content:find("%]%(%s*" .. vim.pesc(rel) .. "[^)]*%)") then
			-- 	table.insert(backlinks, note)
			-- end
		end

		if #note_links ~= 0 then
			backlinks[note] = note_links
		end
	end

	if vim.tbl_isempty(backlinks) then
		return nil
	else
		return backlinks
	end
end

local function find_forward_links()
	local current_note = vim.api.nvim_buf_get_name(0)
	local lines = vim.fn.readfile(current_note)

	-- Markdown inline link matcher:
	-- [label](path)
	-- [label](<path>)
	-- groups:
	--   1 = label
	--   2 = optional "<"
	--   3 = path (file.md, file.md#anchor, folder/file.md)
	--   4 = optional ">"
	-- local pattern = "%[(.-)%]%((<?)([^)%s]+)(>?)%)"
	local pattern = "%]%(%s*<?.*[^)]*>?%)"

	local results = {}

	for linenr, line in ipairs(lines) do
		local start = 1

		while true do
			local s, e, label, open, path, close = line:find(pattern, start)
			if not s then
				break
			end

			table.insert(results, {
				linenr = linenr,
				col = s,
				text = line,
				label = label,
				raw_path = path,
				flanked = (open == "<" and close == ">"),
			})

			start = e + 1
		end
	end

	if vim.tbl_isempty(results) then
		vim.notify("No forward links found", vim.log.levels.INFO)
		return nil
	end

	return results
end

local function rename_file()
	-- Rename current file
	-- Chnage all the link to this file.

	-- Get user input
	-- Mase sure name is valid (does not contains any specail characters, it has a / or anything else)
	-- Find all the links to this file.
	-- Recompute the relative path to this fiel.
	-- Make sure that links to headers still work.
	-- If the file renaming goes ok, then change all the links.

	local current_file_path = vim.api.nvim_buf_get_name(0)
	local current_buffer = vim.api.nvim_get_current_buf()
	local current_file_name = vim.fn.fnamemodify(current_file_path, ":t:r")
	local new_file_name = vim.fn.input("New file name: ", current_file_name)
	local new_file_path = vim.fn.fnamemodify(current_file_path, ":h") .. "/" .. new_file_name .. ".md"
	local lines

	if new_file_name == nil or new_file_name == "" then
		vim.notify("No file name provided", vim.log.levels.ERROR)
		return
	end

	if new_file_name == current_file_name then
		vim.notify("New file name is the same as the old one", vim.log.levels.ERROR)
		return
	end

	-- if vim.fn.filereadable(new_file_name .. ".md") then
	-- 	vim.notify("File already exists", vim.log.levels.ERROR)
	-- 	return
	-- end

	if new_file_name:find("[%z\r\n]") or new_file_name:find("[%z\r\n]") then
		vim.notify("File name contains invalid characters", vim.log.levels.ERROR)
		return
	end

	local backlinks = find_true_backlinks()

	-- Rename the file
	local rename_ok, err = os.rename(current_file_path, new_file_path)
	if not rename_ok then
		if err then
			vim.notify(err, vim.log.levels.ERROR)
		end
		return
	end
	vim.api.nvim_buf_delete(current_buffer, { force = true })

	-- Rename the links
	if backlinks == nil or vim.tbl_isempty(backlinks) then
		vim.notify("No backlinks found.", vim.log.levels.INFO)
	else
		local new_line
		for key, value in pairs(backlinks) do
			-- Read the contents of the file
			lines = vim.fn.readfile(key)

			for _, link in ipairs(value) do
				local line = link.text
				local linenr = link.linenr

				-- Substitute the old link with the new one
				-- new_line = line:gsub(current_file_name, new_file_name)

				local pattern = "(<?)" .. vim.pesc(current_file_name .. ".md") .. "([^)]*)(>?)"

				new_line = line:gsub(pattern, function(a, rest, b)
					return a .. new_file_name .. ".md" .. rest .. b
				end)

				-- Update the lines in the file
				lines[linenr] = new_line
				-- table.remove(lines, linenr)
				-- table.insert(lines, linenr, new_line)
			end

			-- Finaly write to file
			vim.fn.writefile(lines, key)
		end
	end

	-- Reopen the renamed file
	vim.cmd("edit " .. new_file_path)
end

local function move_note()
	-- Move current file
	-- Chnage all the link to this file.

	-- TODO: Find all the occurances of backlinks.
	-- TODO: Show all the possible folders where the note can be moved. Let the user choose.
	-- TODO: Recompute the backlinks.
	-- TODO: Updat the backlinks in other notes
	-- TODO: Update the forward links in the moved file.

	local backlinks = find_true_backlinks()
	local forwardlinks = find_forward_links()

	local current_buffer = vim.api.nvim_get_current_buf()
	local current_file_path = vim.api.nvim_buf_get_name(0)
	local current_file_name = vim.fn.fnamemodify(current_file_path, ":t:r")
	local current_file_exension = vim.fn.fnamemodify(current_file_path, ":e")

	local function tel_move_note(prompt_bufnr, map)
		local function move_note_2()
			local entry = action_state.get_selected_entry()
			local path = entry.path or entry.filename

			-- Close the telescope window
			actions.close(prompt_bufnr)

			-- Add a / at the end of the file path if it doesn't exist
			if path:sub(-1) ~= "/" then
				path = path .. "/"
			end

			-- Create the new file path
			local new_file_path = path .. current_file_name .. "." .. current_file_exension

			-- Ask the user if the selected location is ok?
			local ok = vim.fn.confirm("Move note to:\n" .. new_file_path .. "\nIs this OK?", "&Yes\n&No", 2)
			if ok ~= 1 then
				print("Move cancelled.")
				return
			end

			-- Move the file to the new location
			local rename_ok, err = os.rename(current_file_path, new_file_path)

			-- Check to see if the file was moved successfully
			if not rename_ok then
				if err then
					vim.notify(err, vim.log.levels.ERROR)
				end
				return
			end

			-- Close the current buffer
			vim.api.nvim_buf_delete(current_buffer, { force = true })

			-- Reopen the moved note
			vim.cmd("edit " .. new_file_path)

			-- Update the backlinks in the other notes
			vim.print("backlinks", backlinks)

			if backlinks == nil or vim.tbl_isempty(backlinks) then
				vim.notify("No backlinks found.", vim.log.levels.INFO)
			else
				-- Update the backlinks
				local lines, previous_relative_path, new_relative_path, new_line
				for key, value in pairs(backlinks) do
					lines = vim.fn.readfile(key)
					for _, link in ipairs(value) do
						local line = link.text
						local linenr = link.linenr

						-- Substitute the old link with the new one
						-- new_line = line:gsub(current_file_name, new_file_name)

						previous_relative_path = utils.calculate_relative_path(key, current_file_path, { root_folder = M.opts.notes_folder })
						-- vim.print("previous_relative_path: " .. tostring(previous_relative_path))

						local pattern = "(<?)" .. previous_relative_path .. "([^)]*)(>?)"
						-- vim.print("pattern: " .. pattern)

						new_relative_path = utils.calculate_relative_path(key, new_file_path, { root_folder = M.opts.notes_folder })
						vim.print("new_relative_path: " .. new_relative_path)
						vim.print("key: " .. key)
						vim.print("new_file_path: " .. new_file_path)

						new_line = line:gsub(pattern, function(a, rest, b)
							return a .. new_relative_path .. rest .. b
						end)

						-- Update the lines in the file
						lines[linenr] = new_line
						vim.print("new_line: " .. new_line)
						-- table.remove(lines, linenr)
						-- table.insert(lines, linenr, new_line)
					end

					-- Finaly write to file
					vim.print(lines)
					vim.print(key)
					vim.fn.writefile(lines, key)
				end
			end

			-- Update the forward links
			if forwardlinks == nil or vim.tbl_isempty(forwardlinks) then
				vim.notify("No backlinks found.", vim.log.levels.INFO)
			else
				local current_note = vim.api.nvim_buf_get_name(0)
				local lines = vim.fn.readfile(current_note)

				for _, link in ipairs(forwardlinks) do
					local new_relative_path = utils.calculate_relative_path(new_file_path, link.raw_path, { root_folder = M.opts.notes_folder })
					local line = link.text
					local linenr = link.linenr

					local pattern = "%]%(%s*<?" .. vim.pesc(link.raw_path) .. "[^)]*>?%)"

					local new_line = line:gsub(pattern, function(a, rest, b)
						return a .. new_relative_path .. rest .. b
					end)

					-- Update the lines in the file
					lines[linenr] = new_line
				end
			end
		end

		map("i", "<CR>", move_note_2)
		map("n", "<CR>", move_note_2)
		return true
	end

	builtin.find_files({
		prompt_title = "Find Folder",
		find_command = {
			"sh",
			"-c",
			'printf "%s\n" "$1"; fd . "$1" --type d -H',
			"_", -- $0 (ignored placeholder)
			M.opts.notes_folder, -- $1 → your root, e.g. ~/offline/notesTest
		},
		attach_mappings = tel_move_note,
	})
end

local function show_backlinks()
	local backlinks = find_true_backlinks()

	if backlinks == nil or vim.tbl_isempty(backlinks) then
		vim.notify("No backlinks found.")
		return
	end

	local backlinks_paths = {}
	for key, value in pairs(backlinks) do
		table.insert(backlinks_paths, key)
	end

	vim.ui.select(backlinks_paths, {
		prompt = "Select backlink",
		format_item = function(backlink)
			local item = string.format("%s %-30s", vim.fn.fnamemodify(backlink, ":t:r"), backlink:gsub(vim.fn.expand(M.opts.notes_folder), ""))
			return item
		end,
	}, function(choice)
		if choice then
			vim.cmd("edit " .. choice)
		end
	end)
end

vim.keymap.set("n", "<leader>n", "<Nop>", { desc = "Notes" })

if builtin_ok then
	-- Searching for notes
	vim.keymap.set("n", "<leader>ns", function()
		builtin.find_files({ cwd = M.opts.notes_folder })
	end, { desc = "Search notes" })

	-- Live grep through notes
	vim.keymap.set("n", "<leader>ng", function()
		builtin.live_grep({ cwd = M.opts.notes_folder })
	end, { desc = "Grep notes" })
end

-- Check if the required modules were loaded successfully
if utils_ok and actions_ok and action_state_ok then
	vim.keymap.set("n", "<leader>nl", link_notes, { desc = "Link note" })
end

vim.keymap.set("n", "<leader>nr", rename_file, { desc = "Rename file" })
vim.keymap.set("n", "<leader>nm", move_note, { desc = "Move file" })

vim.keymap.set("n", "<leader>nf", find_forward_links, { desc = "Find forward links" })

if scan_ok and utils_ok then
	vim.keymap.set("n", "<leader>nb", show_backlinks, { desc = "Find true backlinks" })
end
