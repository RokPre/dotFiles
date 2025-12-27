-- GhostMarkers: Treesitter jump peek with priority-based dedupe

local lang = vim.bo.filetype
local enabled = false

local query = vim.treesitter.query.get(lang, "textobjects")
if not query then
	return
end

local user_config = require("nvim-treesitter.configs").get_module("textobjects.move") or {}

local ns = vim.api.nvim_create_namespace("ghost_marker")

-----------------------------------------------------------------------
-- Priority model
-----------------------------------------------------------------------

local jump_type_priority = {
	prev_start = 40,
	prev_end = 30,
	next_start = 20,
	next_end = 10,
}

local capture_priority = {}
local DEFAULT_CAPTURE_PRIORITY = 0

-----------------------------------------------------------------------
-- Helpers
-----------------------------------------------------------------------

local function clamp_col(buf, row, col)
	local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1]
	if not line then
		return nil
	end
	return math.min(math.max(col, 0), #line)
end

local function motion_for_capture(capture, goto_map)
	if not goto_map then
		return nil
	end
	for key, value in pairs(goto_map) do
		if capture == value:sub(2) then
			return key
		end
	end
end

-----------------------------------------------------------------------
-- Treesitter scanning
-----------------------------------------------------------------------

local function collect_nodes()
	local parser = vim.treesitter.get_parser(0, lang)
	local tree = parser:parse()[1]
	local root = tree:root()

	local nodes = {}

	for id, node in query:iter_captures(root, 0) do
		local name = query.captures[id]
		local sr, sc, er, ec = node:range()
		nodes[name] = nodes[name] or {}
		table.insert(nodes[name], { sr, sc, er, ec })
	end

	return nodes
end

local function split_by_cursor(found)
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	row = row - 1

	local ps, pe, ns, ne = {}, {}, {}, {}

	for name, list in pairs(found) do
		for _, n in ipairs(list) do
			local sr, sc, er, ec = unpack(n)

			if sr < row or (sr == row and sc < col) then
				ps[name] = { sr, sc }
			end
			if er < row or (er == row and ec < col) then
				pe[name] = { er, ec }
			end
			if not ns[name] and (sr > row or (sr == row and sc > col)) then
				ns[name] = { sr, sc }
			end
			if not ne[name] and (er > row or (er == row and ec > col)) then
				ne[name] = { er, ec }
			end
		end
	end

	return ps, pe, ns, ne
end

-----------------------------------------------------------------------
-- Marker rendering (deduped by (row,col))
-----------------------------------------------------------------------

local function add_marker(best, row, col, text, score)
	col = clamp_col(0, row, col)
	if not col then
		return
	end
	local key = row .. ":" .. col
	if not best[key] or score > best[key].score then
		best[key] = { row = row, col = col, text = text, score = score }
	end
end

local function apply_markers(best)
	vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
	for _, m in pairs(best) do
		vim.api.nvim_buf_set_extmark(0, ns, m.row, m.col, {
			virt_text = { { m.text, "LineNr" } },
			virt_text_pos = "inline",
		})
	end
end

-----------------------------------------------------------------------
-- Main render
-----------------------------------------------------------------------

local function render()
	if not enabled then
		return
	end

	local found = collect_nodes()
	local ps, pe, ns_, ne = split_by_cursor(found)

	local best = {}

	local function process(nodes, goto_map, kind)
		if not nodes or not goto_map then
			return
		end
		for name, pos in pairs(nodes) do
			local motion = motion_for_capture(name, goto_map)
			if motion then
				local score = jump_type_priority[kind] * 1000 + (capture_priority[name] or DEFAULT_CAPTURE_PRIORITY)
				add_marker(best, pos[1], pos[2], motion, score)
			end
		end
	end

	process(ps, user_config.goto_previous_start, "prev_start")
	process(pe, user_config.goto_previous_end, "prev_end")
	process(ns_, user_config.goto_next_start, "next_start")
	process(ne, user_config.goto_next_end, "next_end")

	apply_markers(best)
end

-----------------------------------------------------------------------
-- Peek mode
-----------------------------------------------------------------------

local function enable_peek()
	enabled = true
	render()

	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
		group = vim.api.nvim_create_augroup("GhostMarkersPeek", { clear = true }),
		once = true,
		callback = function()
			enabled = false
			vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
		end,
	})
end

-----------------------------------------------------------------------
-- Keymap
-----------------------------------------------------------------------

vim.keymap.set("n", "<Leader><Leader>", enable_peek, {
	silent = true,
	desc = "Peek Treesitter jump targets",
})
