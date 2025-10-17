local ts_utils = require("nvim-treesitter.ts_utils")
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local function in_math()
	local node = ts_utils.get_node_at_cursor()
	while node do
		local type = node:type()
		if type == "inline_formula" or type == "displayed_equation" then
			return true
		end
		node = node:parent()
	end
	return false
end

-- Utility function to format links
local function link_for_day(offset, label)
	local time = os.time() + (offset or 0)
	local day_str = os.date("%Y - %j", time)
	if label then
		return "[[" .. day_str .. "|" .. label .. "]]"
	else
		return "[[" .. day_str .. "]]"
	end
end

-- Named variants
local function today()
	return link_for_day(0, "today")
end
local function danes()
	return link_for_day(0, "danes")
end
local function yesterday()
	return link_for_day(-86400)
end
local function uceraj()
	return link_for_day(-86400)
end
local function tomorrow()
	return link_for_day(86400)
end
local function jutri()
	return link_for_day(86400)
end

local function make_matrix(rows, cols)
	local matrix_text = "\\begin{{bmatrix}}\n"
	local matrix_input = {}
	local trigger = "m" .. rows .. "x" .. cols
	local index = 1
	for _ = 1, rows do
		for _ = 1, cols do
			matrix_text = matrix_text .. "{} & "
			table.insert(matrix_input, i(index))
			index = index + 1
		end
		matrix_text = matrix_text .. "\\\\\n"
	end

	matrix_text = matrix_text .. "\\end{{bmatrix}}"

	s(
		{ trig = trigger, wordTrig = true, condition = in_math, snippetType = "autosnippet" },
		fmt(matrix_text, matrix_input)
	)
end

for r = 1, 10, 1 do
	for c = 1, 10, 1 do
		make_matrix(r, c)
	end
end

ls.add_snippets("markdown", {
	-- Inline math
	s({ trig = "mk", snippetType = "autosnippet", wordTrig = true }, { t("$"), i(1), t("$") }),
	-- Display math
	s({ trig = "dm", snippetType = "autosnippet", wordTrig = true }, {
		t({ "$$", "" }),
		i(1),
		t({ "", "$$" }),
	}),

	-- Inline code
	s({ trig = "code", wordTrig = true }, { t("`"), i(1), t("`") }),

	-- Code block
	s({ trig = "codeblock", wordTrig = true }, { t({ "```" }), i(1), t({ "", "" }), i(2), t({ "", "```" }) }),

	-- Date links
	s({ trig = "today", snippetType = "autosnippet", wordTrig = true }, { f(today) }),
	s({ trig = "danes", snippetType = "autosnippet", wordTrig = true }, { f(danes) }),
	s({ trig = "yesterday", snippetType = "autosnippet", wordTrig = true }, { f(yesterday) }),
	s({ trig = "uceraj", snippetType = "autosnippet", wordTrig = true }, { f(uceraj) }),
	s({ trig = "tomorrow", snippetType = "autosnippet", wordTrig = true }, { f(tomorrow) }),
	s({ trig = "jutri", snippetType = "autosnippet", wordTrig = true }, { f(jutri) }),

	-- Latex math
	s(
		{ trig = "fr", wordTrig = true, condition = in_math, snippetType = "autosnippet" },
		fmt("\\frac{{{}}}{{{}}}", { i(1), i(2) })
	),
	s(
		{ trig = "sq", wordTrig = true, condition = in_math, snippetType = "autosnippet" },
		fmt("\\sqrt{{{}}}", { i(1) })
	),
	s({ trig = "_", wordTrig = false, condition = in_math, snippetType = "autosnippet" }, fmt("_{{{}}}", { i(1) })),
	s({ trig = "pow", wordTrig = false, condition = in_math, snippetType = "autosnippet" }, fmt("^{{{}}}", { i(1) })),
	s(
		{ trig = "log", wordTrig = true, condition = in_math, snippetType = "autosnippet" },
		fmt("\\log{{{}}}", { i(1) })
	),
	s(
		{ trig = "text", wordTrig = true, condition = in_math, snippetType = "autosnippet" },
		fmt("\\text{{{}}}", { i(1) })
	),
	s({ trig = "od", wordTrig = false, condition = in_math, snippetType = "autosnippet" }, fmt("({})", { i(1) })),
	s(
		{ trig = "fancy", wordTrig = true, condition = in_math, snippetType = "autosnippet" },
		fmt("\\mathcal{{{}}}", { i(1) })
	),
	s(
		{ trig = "sum", wordTrig = true, condition = in_math, snippetType = "autosnippet" },
		fmt("\\sum_{{{}}}^{{{}}}", { i(1), i(2) })
	),
	s(
		{ trig = "int", wordTrig = true, condition = in_math, snippetType = "autosnippet" },
		fmt("\\int_{{{}}}^{{{}}}", { i(1), i(2) })
	),
	s({ trig = "sin", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("\\sin")),
	s({ trig = "cos", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("\\cos")),
	s({ trig = "nic", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("0")),
	s({ trig = "ena", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("1")),
	s({ trig = "dva", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("2")),
	s({ trig = "tri", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("3")),
	s({ trig = "stiri", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("4")),
	s({ trig = "pet", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("5")),
	s({ trig = "sest", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("6")),
	s({ trig = "sedem", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("7")),
	s({ trig = "osem", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("8")),
	s({ trig = "devet", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("9")),
	s({ trig = "inf", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("\\infty")),
	s({ trig = "al", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("\\alpha")),
	s({ trig = "be", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("\\beta")),
	s({ trig = "la", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("\\lambda")),
	s({ trig = "tau", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("\\tau")),
	s({ trig = "pi", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("\\pi")),
	s({ trig = "om", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("\\omega")),
	s({ trig = "plus", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("+")),
	s({ trig = "minus", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("-")),
	s({ trig = "je", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("=")),
	s({ trig = "cd", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("\\cdot")),
	s({ trig = "nic", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("0")),
	s({ trig = "ne", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("\\ne")),
	s({ trig = "vec", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("\\gt")),
	s({ trig = "manj", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("\\ls")),
	s({ trig = "torej", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("\\Rightarrow")),
	s({ trig = "Rr", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("\\Rightarrow")),
	s({ trig = "rr", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("\\rightarrow")),
	s({ trig = "Lr", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("\\Leftarrow")),
	s({ trig = "lr", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("\\Leftarrow")),
	s({ trig = "tedaj", wordTrig = true, condition = in_math, snippetType = "autosnippet" }, t("\\Leftrightarrow")),
	s(
		{ trig = "m3x3", wordTrig = true, condition = in_math, snippetType = "autosnippet" },
		fmt(
			[[
    \begin{{bmatrix}}
    {} & {} & {} \\
    {} & {} & {} \\
    {} & {} & {}
    \end{{bmatrix}}
    ]],
			{
				i(1),
				i(2),
				i(3),
				i(4),
				i(5),
				i(6),
				i(7),
				i(8),
				i(9),
			}
		)
	),
})

-- Checkboxes
local function check_box()
	local line_num = vim.fn.line(".") - 1 -- 0-indexed
	local line = vim.api.nvim_get_current_line()

	-- Patterns
	local unchecked_pattern = "^%s*%- %[ %] (.*)$"
	local checked_pattern = "^%s*%- %[x%] (.*)$"

	local new_line

	if line:match(unchecked_pattern) then
		local text = line:match(unchecked_pattern)
		new_line = "- [x] " .. text
	elseif line:match(checked_pattern) then
		local text = line:match(checked_pattern)
		new_line = text
	else
		new_line = "- [ ] " .. line
	end

	vim.api.nvim_buf_set_lines(0, line_num, line_num + 1, false, { new_line })
end

-- Footnotes
vim.cmd([[
function! FootnoteComplete(A,L,P)
  return g:footnotes
endfunction
]])

local function new_footnote()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	if not lines then
		return
	end

	local footnotes = {}
	local footnotes_int = {}

	-- Find all the footnotes
	for _, line in ipairs(lines) do
		if line:match("^%s*%[%^.-%]") then
			footnotes[#footnotes + 1] = line:match("^%s*%[%^(.-)%]")
		end
	end

	-- Remove duplicates from footnotes
	local seen, uniq = {}, {}
	for _, item in ipairs(footnotes) do
		if not seen[item] then
			uniq[#uniq + 1] = item
			seen[item] = true
		end
	end
	footnotes = uniq

	vim.g.footnotes = footnotes -- make it visible to Vimscript
	local name = vim.fn.input({
		prompt = "Please enter a footnote name: ",
		completion = "customlist,FootnoteComplete",
		cancelreturn = "__cancel__",
	})

	if not name or name == "__cancel__" then
		return
	end

	local prexisting_footnote = false
	for _, footnote in ipairs(footnotes) do
		if footnote == name then
			prexisting_footnote = true
			break
		end
	end

	-- If the user has no input, find the smallest available intiger
	if name == "" then
		for index, footnote in ipairs(footnotes) do
			local intiger = tonumber(footnote)
			if not intiger then
				intiger = 0
			end
			footnotes_int[index] = intiger
		end

		local smallest_int = 1
		if #footnotes_int ~= 0 then
			-- Find smallest available intiger
			table.sort(footnotes_int)

			for _, num in ipairs(footnotes_int) do
				if num == smallest_int then
					smallest_int = num + 1
				elseif num > smallest_int then
					break
				end
			end
		end

		name = tostring(smallest_int)
	end

	local footnote = "[^" .. name .. "]"
	vim.api.nvim_paste(footnote, false, -1)
	if not prexisting_footnote then
		local bottom_footnote = footnote .. ":  "
		vim.api.nvim_buf_set_lines(vim.api.nvim_get_current_buf(), -1, -1, false, { bottom_footnote })
		vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(0), #bottom_footnote })
		vim.cmd("normal! zz")
		vim.cmd("startinsert")
	end
end

local function goto_footnote(match, bottom)
	local pattern = vim.fn.escape(match, "\\/.*$^~[]")
	vim.fn.setreg("/", pattern)
	vim.api.nvim_win_set_cursor(0, { 1, 0 })
	if bottom then
		vim.cmd("normal! n")
	else
		vim.cmd("normal! N")
	end
end

local function footnotes()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()
	if not line then
		return false, nil
	end

	-- Convert to Lua 1-based indexing
	col = col + 1

	-- Check if the cursor is on a footnote
	local match = nil
	for s, e in line:gmatch("()%[%^.-%]()") do
		if col >= s and col <= e then
			match = line:sub(s, e - 1)
			break
		end
	end

	if not match then
		new_footnote()
		return
	end

	-- Find last footnote definition in file
	local last_index = nil
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	for line_number, l in ipairs(lines) do
		local pattern = "^%s*%[%^" .. vim.pesc(match:sub(3, -2)) .. "%]:"
		if l:match(pattern) then
			last_index = line_number
		end
	end

	-- Detect if we are on the last definition
	local is_bottom = match and line:match("^%s*" .. vim.pesc(match) .. ":") and row == last_index

	goto_footnote(match, is_bottom)
end

local opts = { silent = true, noremap = true, buffer = true }
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown" },
	callback = function()
		vim.keymap.set("n", "<C-c>", check_box, opts)
		vim.keymap.set("n", "<C-A-h>", "<Cmd>bprev<Cr>", opts)
		vim.keymap.set("n", "<C-A-l>", "<Cmd>bnext<Cr>", opts)

		vim.keymap.set("n", "<Leader>oT", function()
			vim.api.nvim_put({
				"<!-- START doctoc -->",
				"<!-- END doctoc -->",
				"",
			}, "l", true, true)
		end, { desc = "Insert doctoc markers with newline" })

		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.spell = false
		vim.keymap.set(
			"n",
			"<Leader>of",
			footnotes,
			{ silent = true, noremap = true, buffer = true, desc = "Footnotes" }
		)
	end,
})
