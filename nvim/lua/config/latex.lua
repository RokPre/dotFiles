vim.api.nvim_create_autocmd("FileType", {
  pattern = { "tex" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = false
  end,
})

local lines = {
  "\\documentclass{article}",
  "\\usepackage{amsmath}",
  "\\begin{document}",
  "\\end{document}",
}

vim.api.nvim_create_autocmd({ "BufWinEnter", "BufReadPost" }, {
  pattern = "main.tex",
  nested = true,
  callback = function()
    local is_empty = vim.fn.line("$") == 1 and vim.fn.getline(1) == ""
    if is_empty then
      vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
    end
  end,
})


local ls     = require("luasnip")
local s      = ls.snippet
local t      = ls.text_node
local i      = ls.insert_node
local f      = ls.function_node
local extras = require("luasnip.extras")
local r      = extras.rep

ls.add_snippets("tex", {
  s({ trig = "alpha", snippetType = "autosnippet", wordTrig = true }, { t("\\alpha"), }),
  s({ trig = "beta", snippetType = "autosnippet", wordTrig = true }, { t("\\beta"), }),
  s({ trig = "gamma", snippetType = "autosnippet", wordTrig = true }, { t("\\gamma"), }),
  s({ trig = "delta", snippetType = "autosnippet", wordTrig = true }, { t("\\delta"), }),
  s({ trig = "epsilon", snippetType = "autosnippet", wordTrig = true }, { t("\\epsilon"), }),
  s({ trig = "zeta", snippetType = "autosnippet", wordTrig = true }, { t("\\zeta"), }),
  s({ trig = "eta", snippetType = "autosnippet", wordTrig = true }, { t("\\eta"), }),
  s({ trig = "theta", snippetType = "autosnippet", wordTrig = true }, { t("\\theta"), }),
  s({ trig = "iota", snippetType = "autosnippet", wordTrig = true }, { t("\\iota"), }),
  s({ trig = "kappa", snippetType = "autosnippet", wordTrig = true }, { t("\\kappa"), }),
  s({ trig = "lambda", snippetType = "autosnippet", wordTrig = true }, { t("\\lambda"), }),
  s({ trig = "mu", snippetType = "autosnippet", wordTrig = true }, { t("\\mu"), }),
  s({ trig = "nu", snippetType = "autosnippet", wordTrig = true }, { t("\\nu"), }),
  s({ trig = "xi", snippetType = "autosnippet", wordTrig = true }, { t("\\xi"), }),
  s({ trig = "pi", snippetType = "autosnippet", wordTrig = true }, { t("\\pi"), }),
  s({ trig = "rho", snippetType = "autosnippet", wordTrig = true }, { t("\\rho"), }),
  s({ trig = "sigma", snippetType = "autosnippet", wordTrig = true }, { t("\\sigma"), }),
  s({ trig = "tau", snippetType = "autosnippet", wordTrig = true }, { t("\\tau"), }),
  s({ trig = "phi", snippetType = "autosnippet", wordTrig = true }, { t("\\phi"), }),
  s({ trig = "chi", snippetType = "autosnippet", wordTrig = true }, { t("\\chi"), }),
  s({ trig = "psi", snippetType = "autosnippet", wordTrig = true }, { t("\\psi"), }),
  s({ trig = "omega", snippetType = "autosnippet", wordTrig = true }, { t("\\omega"), }),
  -- Capital
  s({ trig = "Gamma", snippetType = "autosnippet", wordTrig = true }, { t("\\Gamma"), }),
  s({ trig = "Delta", snippetType = "autosnippet", wordTrig = true }, { t("\\Delta"), }),
  s({ trig = "Theta", snippetType = "autosnippet", wordTrig = true }, { t("\\Theta"), }),
  s({ trig = "Lambda", snippetType = "autosnippet", wordTrig = true }, { t("\\Lambda"), }),
  s({ trig = "Xi", snippetType = "autosnippet", wordTrig = true }, { t("\\Xi"), }),
  s({ trig = "Pi", snippetType = "autosnippet", wordTrig = true }, { t("\\Pi"), }),
  s({ trig = "Sigma", snippetType = "autosnippet", wordTrig = true }, { t("\\Sigma"), }),
  s({ trig = "Phi", snippetType = "autosnippet", wordTrig = true }, { t("\\Phi"), }),
  s({ trig = "Psi", snippetType = "autosnippet", wordTrig = true }, { t("\\Psi"), }),
  s({ trig = "Omega", snippetType = "autosnippet", wordTrig = true }, { t("\\omega"), }),
  -- Var
  s({ trig = "vphi", snippetType = "autosnippet", wordTrig = true }, { t("\\varphi"), }),

  s({ trig = "mk", snippetType = "autosnippet", wordTrig = true }, { t("$"), i(1), t("$"), i(2) }),
  s({ trig = "dm", snippetType = "autosnippet", wordTrig = true }, {
    t({ "\\begin{equation}", "" }),
    i(1),
    t({ "", "\\end{equation}" }), }),
  s({ trig = "plus", snippetType = "autosnippet", wordTrig = true }, { t("+"), }),
  s({ trig = "minus", snippetType = "autosnippet", wordTrig = true }, { t("-"), }),
  s("je", { t("= "), }),
  s("fr", { t("\\frac{"), i(1), t({ "}{" }), i(2), t({ "}", "" }), }),
  s("vec", { t("\\vec{"), i(1), t({ "} " }), i(2) }),
  s("cd", { t("\\cdot ") }),
  s("abs", { t("|"), i(1), t("|"), i(2) }),
  s("RA", { t("\\Rightarrow ") }),
  s("LA", { t("\\Leftarrow ") }),
  s("nic", { t("0") }),
  s("beg", { t("\\begin{"), i(1), t({ "}", "" }),
    i(2),
    t({ "", "\\end{" }), r(1), t({ "}" }), }),
})
