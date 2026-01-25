vim.api.nvim_create_autocmd("FileType", {
	pattern = { "tex" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.spell = false
	end,
})


local ls_ok, ls = pcall(require,"luasnip")
if not ls_ok then
	return
end

local tsu_ok, ts_utils = pcall(require, "nvim-treesitter.ts_utils")

local fmt_ok, fmt_mod = pcall(require, "luasnip.extras.fmt")
local fmt = fmt_mod.fmt
local extras_ok, extras = pcall(require, "luasnip.extras")

local rep
if extras_ok then
	rep = extras.rep
	rep_ok = true
end

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node


local function in_math_latex()
	if not tsu_ok then
		return false
	end

	local node = ts_utils.get_node_at_cursor()
	if not node then
		return false
	end

	while node do
		local t = node:type()

		-- inline math: $...$
		if t == "inline_formula" then
			return true
		end

		-- display math: $$...$$
		if t == "displayed_equation" then
			return true
		end

		-- equation, align, gather, etc. (if supported)
		if t == "math_environment" then
			return true
		end

		node = node:parent()
	end

	return false
end

local function make_matrix(rows, cols)
	if not fmt_ok then
		return false
	end
	local matrix_text = "\\begin{{bmatrix}}\n"
	local matrix_input = {}
	local trigger = "m" .. rows .. "x" .. cols
	local index = 1
	for r = 1, rows do
		for c = 1, cols do
			if c == cols then
				matrix_text = matrix_text .. "{}"
			else
				matrix_text = matrix_text .. "{} & "
			end

			table.insert(matrix_input, i(index))
			index = index + 1
		end
		if r == rows then
			matrix_text = matrix_text .. "\n"
		else
			matrix_text = matrix_text .. "\\\\\n"
		end
	end

	matrix_text = matrix_text .. "\\end{{bmatrix}}"

	return s({ trig = trigger, wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, fmt(matrix_text, matrix_input))
end

for r = 1, 10, 1 do
	for c = 1, 10, 1 do
		ls.add_snippets("tex", { make_matrix(r, c) })
	end
end

ls.add_snippets("tex", {
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


})

if fmt_ok then
	ls.add_snippets("tex", {
		-- Latex math
		s({ trig = "fr", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, fmt("\\frac{{{}}}{{{}}}", { i(1), i(2) })),
		s({ trig = "sq", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, fmt("\\sqrt{{{}}}", { i(1) })),
		s({ trig = "sr", wordTrig = false, condition = in_math_latex, snippetType = "autosnippet" }, t("^{2}")),
		s({ trig = "inv", wordTrig = false, condition = in_math_latex, snippetType = "autosnippet" }, t("^{-1}")),
		s({ trig = "pow", wordTrig = false, condition = in_math_latex, snippetType = "autosnippet" }, fmt("^{{{}}}", { i(1) })),
		-- s({ trig = "na", wordTrig = false, condition = in_math_latex, snippetType = "autosnippet" }, fmt("^{{{}}}", { i(1) })),
		s({ trig = "_", wordTrig = false, condition = in_math_latex, snippetType = "autosnippet" }, fmt("_{{{}}}", { i(1) })),
		s({ trig = "log", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, fmt("\\log{{{}}}", { i(1) })),
		s({ trig = "text", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, fmt("\\text{{{}}}", { i(1) })),
		s({ trig = "od", wordTrig = false, condition = in_math_latex, snippetType = "autosnippet" }, fmt("({})", { i(1) })),
		s({ trig = "fancy", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, fmt("\\mathcal{{{}}}", { i(1) })),
		s({ trig = "abs", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, fmt("|{}|", { i(1) })),
		s({ trig = "lim", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, fmt("\\lim_{{{}}}", { i(1) })),
		s({ trig = "res", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, fmt("\\underset{{{}}}{{\\operatorname{{Res}}}}", { i(1) })),
		s({ trig = "Res", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, fmt("\\underset{{{}}}{{\\operatorname{{Res}}}}", { i(1) })),

		s({ trig = "sum", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, fmt("\\sum_{{{}}}^{{{}}}", { i(1), i(2) })),
		s({ trig = "int", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, fmt("\\int_{{{}}}^{{{}}}", { i(1), i(2) })),
		s({ trig = "oint", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, fmt("\\oint_{{{}}}^{{{}}}", { i(1), i(2) })),

		s({ trig = "sin", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("\\sin")),
		s({ trig = "cos", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("\\cos")),
		s({ trig = "tan", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("\\tan")),

		s({ trig = "nic", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("0")),
		s({ trig = "ena", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("1")),
		s({ trig = "dva", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("2")),
		s({ trig = "tri", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("3")),
		s({ trig = "stiri", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("4")),
		s({ trig = "pet", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("5")),
		s({ trig = "sest", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("6")),
		s({ trig = "sedem", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("7")),
		s({ trig = "osem", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("8")),
		s({ trig = "devet", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("9")),

		s({ trig = "inf", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("\\infty")),
		s({ trig = "alpha", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("\\alpha")),
		s({ trig = "beta", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("\\beta")),
		s({ trig = "lambda", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("\\lambda")),
		s({ trig = "tau", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("\\tau")),
		s({ trig = "pi", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("\\pi")),
		s({ trig = "omega", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("\\omega")),
		s({ trig = "delta", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("\\delt")),
		s({ trig = "gamma", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("\\gamma")),

		s({ trig = "plus", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("+")),
		s({ trig = "minus", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("-")),
		s({ trig = "je", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("=")),
		s({ trig = "cd", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("\\cdot")),
		s({ trig = "ne", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("\\ne")),
		s({ trig = "vec", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, fmt("\\vec{{{}}}{}", { i(1), i(2) })),
		s({ trig = "manj", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("\\ls")),
		s({ trig = "proti", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("\\rightarrow")),
		s({ trig = "torej", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("\\Rightarrow")),
		s({ trig = "Rr", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("\\Rightarrow")),
		s({ trig = "rr", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("\\rightarrow")),
		s({ trig = "Lr", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("\\Leftarrow")),
		s({ trig = "lr", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("\\Leftarrow")),
		s({ trig = "tedaj", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("\\Leftrightarrow")),
		s({ trig = "...", wordTrig = true, condition = in_math_latex, snippetType = "autosnippet" }, t("\\dots")),
		-- Begins
		s({ trig = "cases", wordTrig = false, snippetType = "autosnippet" }, fmt("\\begin{{cases}}\n{}\n\\end{{cases}}", { i(1) })),
		s({ trig = "align", wordTrig = false, snippetType = "autosnippet" }, fmt("\\begin{{align}}\n{}\n\\end{{align}}", { i(1) })),
		s({ trig = "eq", wordTrig = false, snippetType = "autosnippet" }, fmt("\\begin{{equation}}\n{}\n\\end{{equation}}", { i(1) })),
		s({ trig = "gather", wordTrig = false, snippetType = "autosnippet" }, fmt("\\begin{{gather}}\n{}\n\\end{{gather}}", { i(1) })),
		s({ trig = "split", wordTrig = false, snippetType = "autosnippet" }, fmt("\\begin{{split}}\n{}\n\\end{{split}}", { i(1) })),
	})
end
if rep_ok then
	ls.add_snippets("tex", {

		s({ trig = "beg", wordTrig = false, snippetType = "autosnippet" }, { t("\\begin{"), i(1), t({ "}", "" }), i(2), t({ "", "\\end{" }), rep(1), t({ "}" }) }),
	})
end
