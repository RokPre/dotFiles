-- GhostMarkers with priority-based dedupe per (row,col)
-- Keeps only the most important jump marker at each position, even if multiple
-- textobjects and multiple move-maps point to the same spot.

local enabled = true
local lang = vim.bo.filetype
local query = vim.treesitter.query.get(lang, "textobjects")

if not query then
	vim.notify("No textobjects query for language: " .. lang, vim.log.levels.WARN)
	return
end

-- 1) Read user's nvim-treesitter textobjects.move config
local user_config = require("nvim-treesitter.configs").get_module("textobjects.move")

-- Collect all capture names that the user maps (e.g. "@function.outer")
local nodes_to_search_for = {}
local user_config_goto = {
	user_config.goto_next,
	user_config.goto_next_start,
	user_config.goto_next_end,
	user_config.goto_previous_start,
	user_config.goto_previous_end,
}
for _, value in pairs(user_config_goto) do
	for _, v in pairs(value) do
		nodes_to_search_for[#nodes_to_search_for + 1] = v
	end
end

-- Deduplicate capture names
local seen, unique_nodes_to_search_for = {}, {}
for _, v in ipairs(nodes_to_search_for) do
	if not seen[v] then
		seen[v] = true
		unique_nodes_to_search_for[#unique_nodes_to_search_for + 1] = v
	end
end

-- 2) Find all occurrences for captures
local function find_all_occurrences(nodes_to_search_for_)
	local parser = vim.treesitter.get_parser(0, lang)
	local tree = parser:parse()[1]
	local root = tree:root()

	local found_nodes = {}
	for id, node in query:iter_captures(root, 0, 0, -1) do
		local name = query.captures[id]
		for _, v in pairs(nodes_to_search_for_) do
			if name == v:sub(2) then
				local sr, sc, er, ec = node:range()
				found_nodes[name] = found_nodes[name] or {}
				table.insert(found_nodes[name], { sr, sc, er, ec })
			end
		end
	end
	return found_nodes
end

-- 2.1) Find previous/next start/end relative to cursor
local function find_previous_and_next_occurrence(found_nodes)
	local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
	cursor_row = cursor_row - 1

	local previous_ends, previous_starts, next_ends, next_starts = {}, {}, {}, {}

	for name, nodes in pairs(found_nodes) do
		for _, node in ipairs(nodes) do
			local sr, sc, er, ec = unpack(node)

			if sr < cursor_row or (sr == cursor_row and sc < cursor_col) then
				previous_starts[name] = { sr, sc }
			end

			if er < cursor_row or (er == cursor_row and ec < cursor_col) then
				previous_ends[name] = { er, ec }
			end

			if not next_starts[name] and (sr > cursor_row or (sr == cursor_row and sc > cursor_col)) then
				next_starts[name] = { sr, sc }
			end

			if not next_ends[name] and (er > cursor_row or (er == cursor_row and ec > cursor_col)) then
				next_ends[name] = { er, ec }
			end
		end
	end

	return { previous_starts, previous_ends, next_starts, next_ends }
end

-- 3) Markers with priority-based dedupe

local ns = vim.api.nvim_create_namespace("ghost_marker")

-- You asked for a dict of jump-types and their priority.
-- Here "jump-type" = which of the 4 marker sets we are placing.
-- Higher number wins when two markers land on the same (row,col).
local jump_type_priority = {
	prev_start = 40,
	prev_end = 30,
	next_start = 20,
	next_end = 10,
}

-- Optional: a secondary priority among captures (textobjects) themselves.
-- If you want, populate this with your own preferences.
-- Higher wins if jump_type_priority ties.
local capture_priority = {
	-- examples (change as you like):
	-- ["function.outer"] = 100,
	-- ["class.outer"] = 90,
	-- ["method.outer"] = 80,
	-- ["parameter.inner"] = 10,
}
local DEFAULT_CAPTURE_PRIORITY = 0

local function clamp_col(buf, row, col)
	local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1]
	if not line then
		return nil
	end
	local max_col = #line
	if col > max_col then
		col = max_col
	end
	if col < 0 then
		col = 0
	end
	return col
end

local function motion_for_capture(capture_name, goto_map)
	for key, value in pairs(goto_map) do
		if capture_name == value:sub(2) then
			return key
		end
	end
	return nil
end

-- Build a best-marker-per-position table, then render once.
-- This solves duplicates even when:
-- - multiple jump types collide
-- - multiple captures land on same row/col
-- - multiple motions map to same capture at same position
local function add_best_marker(best, buf, row, col, virt_text, score)
	col = clamp_col(buf, row, col)
	if col == nil then
		return
	end
	local k = row .. ":" .. col
	local cur = best[k]
	if not cur or score > cur.score then
		best[k] = { row = row, col = col, virt_text = virt_text, score = score }
	end
end

local function set_markers_dedup(best, nodes, goto_map, jump_type)
	local jt_score = jump_type_priority[jump_type] or 0

	for capture_name, pos in pairs(nodes) do
		local motion = motion_for_capture(capture_name, goto_map)
		if motion and pos then
			local row, col = pos[1], pos[2]

			local cap_score = capture_priority[capture_name] or DEFAULT_CAPTURE_PRIORITY
			local score = jt_score * 1000 + cap_score

			add_best_marker(best, 0, row, col, { { motion, "LineNr" } }, score)
		end
	end
end

local function render_best(best)
	vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
	for _, m in pairs(best) do
		vim.api.nvim_buf_set_extmark(0, ns, m.row, m.col, {
			virt_text = m.virt_text,
			virt_text_pos = "inline",
		})
	end
end

local function refresh_marks(found_nodes)
	if not enabled then
		return
	end
	local prev_s, prev_e, next_s, next_e = unpack(find_previous_and_next_occurrence(found_nodes))

	local best = {}

	set_markers_dedup(best, prev_s, user_config.goto_previous_start, "prev_start")
	set_markers_dedup(best, prev_e, user_config.goto_previous_end, "prev_end")
	set_markers_dedup(best, next_s, user_config.goto_next_start, "next_start")
	set_markers_dedup(best, next_e, user_config.goto_next_end, "next_end")

	render_best(best)
end

-- 4) Autocmds
local found_nodes = find_all_occurrences(unique_nodes_to_search_for)
refresh_marks(found_nodes)

local group = vim.api.nvim_create_augroup("GhostMarkers", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI", "BufWritePost" }, {
	group = group,
	callback = function()
		found_nodes = find_all_occurrences(unique_nodes_to_search_for)
		refresh_marks(found_nodes)
	end,
})

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
	group = group,
	callback = function()
		refresh_marks(found_nodes)
	end,
})

vim.api.nvim_create_user_command("TreesitterMarks", function()
	if enabled then
		enabled = false
		vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
		pcall(vim.api.nvim_del_augroup_by_name, "GhostMarkers")
	else
		enabled = true
		group = vim.api.nvim_create_augroup("GhostMarkers", { clear = true })
		found_nodes = find_all_occurrences(unique_nodes_to_search_for)
		refresh_marks(found_nodes)

		vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI", "BufWritePost" }, {
			group = group,
			callback = function()
				found_nodes = find_all_occurrences(unique_nodes_to_search_for)
				refresh_marks(found_nodes)
			end,
		})

		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			group = group,
			callback = function()
				refresh_marks(found_nodes)
			end,
		})
	end
end, {})
