local enabled = true
local lang = vim.bo.filetype
local query = vim.treesitter.query.get(lang, "textobjects")

if not query then
	vim.notify("No textobjects query for language:" .. lang, vim.log.levels.WARN)
	return
end

-- 1. Get all the users configuration for treesitter moves.
local user_config = require("nvim-treesitter.configs").get_module("textobjects.move")
local nodes_to_serach_for = {}
local user_config_goto = {
	user_config.goto_next,
	user_config.goto_next_start,
	user_config.goto_next_end,
	user_config.goto_previous_start,
	user_config.goto_previous_end,
}
for _, value in pairs(user_config_goto) do
	for _, v in pairs(value) do
		nodes_to_serach_for[#nodes_to_serach_for + 1] = v
	end
end

-- Deduplicate nodes
local seen, unique_nodes_to_serach_for = {}, {}
for _, v in ipairs(nodes_to_serach_for) do
	if not seen[v] then
		seen[v] = true
		unique_nodes_to_serach_for[#unique_nodes_to_serach_for + 1] = v
	end
end

-- 2. Find all the nodes that match the users configuration.
local function find_all_occurances(nodes_to_search_for)
	local parser = vim.treesitter.get_parser(0, lang)
	local tree = parser:parse()[1]
	local root = tree:root()

	local found_nodes = {}
	for id, node in query:iter_captures(root, 0, 0, -1) do
		local name = query.captures[id]
		-- vim.print(name)
		for _, v in pairs(nodes_to_search_for) do
			if name == v:sub(2) then
				local sr, sc, er, ec = node:range()
				if not found_nodes[name] then
					found_nodes[name] = {}
				end
				table.insert(found_nodes[name], { sr, sc, er, ec })
			end
		end
	end
	return found_nodes
end

-- 2.1 Find the previous and next occurrence of the node.
local function find_previous_and_next_occurance(found_nodes)
	local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
	cursor_row = cursor_row - 1 -- make 0-based to match node:range()

	local previous_ends, previous_starts, next_ends, next_starts = {}, {}, {}, {}

	for name, nodes in pairs(found_nodes) do
		for _, node in ipairs(nodes) do
			local sr, sc, er, ec = unpack(node)

			-- previous start
			if sr < cursor_row or (sr == cursor_row and sc < cursor_col) then
				previous_starts[name] = { sr, sc }
			end

			-- previous end
			if er < cursor_row or (er == cursor_row and ec < cursor_col) then
				previous_ends[name] = { er, ec }
			end

			-- next start
			if not next_starts[name] and (sr > cursor_row or (sr == cursor_row and sc > cursor_col)) then
				next_starts[name] = { sr, sc }
			end

			-- next end
			if not next_ends[name] and (er > cursor_row or (er == cursor_row and ec > cursor_col)) then
				next_ends[name] = { er, ec }
			end
		end
	end

	return { previous_starts, previous_ends, next_starts, next_ends }
end

-- 3. Add a marker in the relevant place.
local ns = vim.api.nvim_create_namespace("ghost_marker")

local function set_markers(nodes, user_config)
	for name, pos in pairs(nodes) do
		local motion
		for key, value in pairs(user_config) do
			if name == value:sub(2) then
				motion = key
				break
			end
		end

		if motion and pos then
			local row, col = pos[1], pos[2]
			-- Clamp column to valid range for the line
			local line = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1]
			if line then
				local max_col = #line
				if col > max_col then
					col = max_col
				end
				vim.api.nvim_buf_set_extmark(0, ns, row, col, {
					virt_text = { { motion, "LineNr" } },
					virt_text_pos = "inline",
				})
			end
		end
	end
end

-- 4. Auto commands
local found_nodes = find_all_occurances(unique_nodes_to_serach_for)
local previous_starts, previous_ends, next_starts, next_ends = unpack(find_previous_and_next_occurance(found_nodes))

vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
set_markers(previous_starts, user_config.goto_previous_start)
set_markers(previous_ends, user_config.goto_previous_end)
set_markers(next_starts, user_config.goto_next_start)
set_markers(next_ends, user_config.goto_next_end)

local group = vim.api.nvim_create_augroup("GhostMarkers", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI", "BufWritePost" }, {
	group = group,
	callback = function()
		found_nodes = find_all_occurances(unique_nodes_to_serach_for)
		local prev_s, prev_e, next_s, next_e = unpack(find_previous_and_next_occurance(found_nodes))
		vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
		set_markers(prev_s, user_config.goto_previous_start)
		set_markers(prev_e, user_config.goto_previous_end)
		set_markers(next_s, user_config.goto_next_start)
		set_markers(next_e, user_config.goto_next_end)
	end,
})

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
	group = group,
	callback = function()
		local prev_s, prev_e, next_s, next_e = unpack(find_previous_and_next_occurance(found_nodes))
		vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
		set_markers(prev_s, user_config.goto_previous_start)
		set_markers(prev_e, user_config.goto_previous_end)
		set_markers(next_s, user_config.goto_next_start)
		set_markers(next_e, user_config.goto_next_end)
	end,
})

vim.api.nvim_create_user_command("TreesitterMarks", function()
	if enabled then
		enabled = false
		vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
		vim.api.nvim_del_augroup_by_name("GhostMarkers")
	else
		enabled = true
		group = vim.api.nvim_create_augroup("GhostMarkers", { clear = true })
		found_nodes = find_all_occurances(unique_nodes_to_serach_for)
		local prev_s, prev_e, next_s, next_e = unpack(find_previous_and_next_occurance(found_nodes))
		vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
		set_markers(prev_s, user_config.goto_previous_start)
		set_markers(prev_e, user_config.goto_previous_end)
		set_markers(next_s, user_config.goto_next_start)
		set_markers(next_e, user_config.goto_next_end)
		vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI", "BufWritePost" }, {
			group = group,
			callback = function()
				found_nodes = find_all_occurances(unique_nodes_to_serach_for)
				local prev_s, prev_e, next_s, next_e = unpack(find_previous_and_next_occurance(found_nodes))
				vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
				set_markers(prev_s, user_config.goto_previous_start)
				set_markers(prev_e, user_config.goto_previous_end)
				set_markers(next_s, user_config.goto_next_start)
				set_markers(next_e, user_config.goto_next_end)
			end,
		})

		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			group = group,
			callback = function()
				local prev_s, prev_e, next_s, next_e = unpack(find_previous_and_next_occurance(found_nodes))
				vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
				set_markers(prev_s, user_config.goto_previous_start)
				set_markers(prev_e, user_config.goto_previous_end)
				set_markers(next_s, user_config.goto_next_start)
				set_markers(next_e, user_config.goto_next_end)
			end,
		})
	end
end, {})
