-- TODO: Paste image
-- TODO: Rename file (update all the links)
-- TODO: Move file (update all the links)
-- TODO: Templates
-- TODO: Embed excalidraw
-- TODO: Obsidian daily note
-- TODO: Tags
-- TODO: Add notes to cmp, and their aliases
-- TODO: Floating diary

local notes_folder = "~/sync/knowledgeVault/"

local ok, builtin = pcall(require, "telescope.builtin")
-- Check if the laod the required modules
local actions_ok, actions = pcall(require, "telescope.actions")
local action_state_ok, action_state = pcall(require, "telescope.actions.state")

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

local function calculate_relative_file_path(current_file_path, note_path, root_folder)
	-- current_file_path - the file that i am currently in. THe file in which i wouldl ike to insert the link.
	-- note_path - The file that i would like the link to point at.
	local parent_folder = vim.fn.fnamemodify(current_file_path, ":p:h")
	local found = nil
	local relative_file_path = ""

	root_folder = vim.fn.expand(root_folder)

	while parent_folder ~= vim.fn.fnamemodify(root_folder, ":h") do
		if vim.startswith(note_path, parent_folder) then
			found = parent_folder
			break
		end
		parent_folder = vim.fn.fnamemodify(parent_folder, ":h")
		relative_file_path = relative_file_path .. "../"
	end

	local rel = note_path:sub(#found + 2)
	return relative_file_path .. rel
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

			local relative_file_path = calculate_relative_file_path(current_file_path, path, notes_folder)
			-- vim.print("current_file_path:", current_file_path)
			-- vim.print("path:", path)
			-- vim.print("relative_file_path:", relative_file_path)

			local function paste_link(link_name)
				local link = string.format("[%s](%s)", link_name, relative_file_path)
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
		cwd = notes_folder,
		prompt_title = "Link note",
		attach_mappings = link_notes_2,
	})
end

local function find_backlinks()
	local file_path = vim.api.nvim_buf_get_name(0)
	local file_name = vim.fn.fnamemodify(file_path, ":t")

	-- Telescope live grep for file_name, but also check if the link is right, as it is relative and if two notes exist with the same name in different folders, it causes problmes.
	builtin.live_grep({
		cwd = notes_folder,
		search = file_name,
	})
end

local function rename_file() end

vim.keymap.set("n", "<leader>n", "<Nop>", { desc = "Notes" })

if ok then
	vim.keymap.set("n", "<leader>ns", function()
		builtin.find_files({ cwd = notes_folder })
	end, { desc = "Search notes" })

	vim.keymap.set("n", "<leader>ng", function()
		builtin.live_grep({ cwd = notes_folder })
	end, { desc = "Grep notes" })

	-- Check if the required modules were loaded successfully
	if actions_ok and action_state_ok then
		vim.keymap.set("n", "<leader>nl", link_notes, { desc = "Link note" })
	end

	vim.keymap.set("n", "<leader>nr", rename_file, { desc = "Rename file" })
	vim.keymap.set("n", "<leader>nb", find_backlinks, { desc = "Find backlinks" })
end

local Path = require("plenary.path")
local scan = require("plenary.scandir")

local function find_true_backlinks()
	local current = vim.api.nvim_buf_get_name(0)
	local notes_root = vim.fn.expand("~/sync/knowledgeVault")
	local backlinks = {}

	-- scan all markdown files
	local files = scan.scan_dir(notes_root, { depth = 10, search_pattern = "%.md$" })

	vim.print("number of files: ", #files)

	for _, other in ipairs(files) do
		if other ~= current then
			-- compute expected relative link from 'other' → 'current'
			local rel = calculate_relative_file_path(other, current, notes_root)

			-- check if that exact relative path string appears in the other file
			local content = table.concat(vim.fn.readfile(other), "\n")
			if content:find("%]%(%s*" .. vim.pesc(rel) .. "%s*%)") then
				table.insert(backlinks, other)
			end
		end
	end

	if #backlinks == 0 then
		print("No backlinks found.")
	else
		vim.ui.select(backlinks, {
			prompt = "Select backlink",
			format_item = function(backlink)
				return backlink:gsub(vim.fn.expand(notes_root), "")
			end,
		}, function(choice)
			if choice then
				vim.cmd("edit " .. choice)
			end
		end)
	end
end

vim.keymap.set("n", "<leader>nb", find_true_backlinks, { desc = "Find true backlinks" })
