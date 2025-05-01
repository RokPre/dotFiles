local lines = {
  "\\documentclass{article}",
  "\\usepackage{amsmath}",
  "\\begin{document}",
  "\\end{document}",
}

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "main.tex",
  nested = true,
  callback = function()
    local is_empty = vim.fn.line("$") == 1 and vim.fn.getline(1) == ""
    if is_empty then
      vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
    end
  end,
})


local ls = require("luasnip")
local s  = ls.snippet
local t  = ls.text_node
local i = ls.insert_node
local f  = ls.function_node
local extras = require("luasnip.extras")
local r = extras.rep

ls.add_snippets("tex", {
  s({trig = "alpha", snippetType = "autosnippet", wordTrig = false}, { t("\\alpha"), }),
  s({trig = "beta", snippetType = "autosnippet", wordTrig = false}, { t("\\beta"), }),
  s({trig = "gamma", snippetType = "autosnippet", wordTrig = false}, { t("\\gamma"), }),
  s({trig = "delta", snippetType = "autosnippet", wordTrig = false}, { t("\\delta"), }),
  s({trig = "epsilon", snippetType = "autosnippet", wordTrig = false}, { t("\\epsilon"), }),
  s({trig = "zeta", snippetType = "autosnippet", wordTrig = false}, { t("\\zeta"), }),
  s({trig = "eta", snippetType = "autosnippet", wordTrig = false}, { t("\\eta"), }),
  s({trig = "theta", snippetType = "autosnippet", wordTrig = false}, { t("\\theta"), }),
  s({trig = "iota", snippetType = "autosnippet", wordTrig = false}, { t("\\iota"), }),
  s({trig = "kappa", snippetType = "autosnippet", wordTrig = false}, { t("\\kappa"), }),
  s({trig = "lambda", snippetType = "autosnippet", wordTrig = false}, { t("\\lambda"), }),
  s({trig = "mu", snippetType = "autosnippet", wordTrig = false}, { t("\\mu"), }),
  s({trig = "nu", snippetType = "autosnippet", wordTrig = false}, { t("\\nu"), }),
  s({trig = "xi", snippetType = "autosnippet", wordTrig = false}, { t("\\xi"), }),
  s({trig = "pi", snippetType = "autosnippet", wordTrig = false}, { t("\\pi"), }),
  s({trig = "rho", snippetType = "autosnippet", wordTrig = false}, { t("\\rho"), }),
  s({trig = "sigma", snippetType = "autosnippet", wordTrig = false}, { t("\\sigma"), }),
  s({trig = "tau", snippetType = "autosnippet", wordTrig = false}, { t("\\tau"), }),
  s({trig = "phi", snippetType = "autosnippet", wordTrig = false}, { t("\\phi"), }),
  s({trig = "chi", snippetType = "autosnippet", wordTrig = false}, { t("\\chi"), }),
  s({trig = "psi", snippetType = "autosnippet", wordTrig = false}, { t("\\psi"), }),
  s({trig = "omega", snippetType = "autosnippet", wordTrig = false}, { t("\\omega"), }),
   -- Capital
  s({trig = "Gamma", snippetType = "autosnippet", wordTrig = false}, { t("\\Gamma"), }),
  s({trig = "Delta", snippetType = "autosnippet", wordTrig = false}, { t("\\Delta"), }),
  s({trig = "Theta", snippetType = "autosnippet", wordTrig = false}, { t("\\Theta"), }),
  s({trig = "Lambda", snippetType = "autosnippet", wordTrig = false}, { t("\\Lambda"), }),
  s({trig = "Xi", snippetType = "autosnippet", wordTrig = false}, { t("\\Xi"), }),
  s({trig = "Pi", snippetType = "autosnippet", wordTrig = false}, { t("\\Pi"), }),
  s({trig = "Sigma", snippetType = "autosnippet", wordTrig = false}, { t("\\Sigma"), }),
  s({trig = "Phi", snippetType = "autosnippet", wordTrig = false}, { t("\\Phi"), }),
  s({trig = "Psi", snippetType = "autosnippet", wordTrig = false}, { t("\\Psi"), }),
  s({trig = "Omega", snippetType = "autosnippet", wordTrig = false}, { t("\\omega"), }),
  -- Var
  s({trig = "vphi", snippetType = "autosnippet", wordTrig = false}, { t("\\varphi"), }),

  s({trig = "mk", snippetType = "autosnippet", wordTrig = false}, { t("$"), i(1), t("$"), i(2)}),
  s({trig = "dm", snippetType = "autosnippet", wordTrig = false}, {
            t({"\\begin{equation}", ""}),
            i(1),
            t({"", "\\end{equation}"}), }),
  s({trig = "plus", snippetType = "autosnippet", wordTrig = false}, { t("+"), }),
  s({trig = "minus",snippetType = "autosnippet", wordTrig = false},  { t("-"), }),
  s("je", { t("= "), }),
  s("fr", { t("\\frac{"), i(1), t({"}{"}), i(2), t({"}", ""}), }),
  s("vec", { t("\\vec{"), i(1), t({"} "}), i(2) }),
  s("cd", { t("\\cdot ") }),
  s("abs", { t("|"), i(1), t("|"), i(2) }),
  s("RA", { t("\\Rightarrow ") }),
  s("LA", { t("\\Leftarrow ") }),
  s("nic", { t("0") }),
  s("beg", { t("\\begin{"), i(1), t({"}", ""}),
             i(2),
             t({"", "\\end{"}), r(1), t({"}"}), }),
})
