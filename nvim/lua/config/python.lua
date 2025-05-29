local lines = {
  "#! /usr/bin/python3",
  "",
  "",
  "def init():",
  "    pass",
  "",
  "",
  "def main():",
  "    pass",
  "",
  "",
  "def exception():",
  "    pass",
  "",
  "",
  "def finalize():",
  "    pass",
  "",
  "",
  'if __name__ == "__main__":',
  "    try:",
  "        init()",
  "        main()",
  "    except:",
  "        exception()",
  "    finally:",
  "        finalize()",
}

vim.api.nvim_create_autocmd({ "BufWinEnter", "BufReadPost" }, {
  pattern = "main.py",
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
local f  = ls.function_node
local function last_yanked()
  vim.cmd('normal! gv"0y')
  local content = vim.fn.getreg("0"):gsub("\n", "")
  -- Split on newline into a table; if empty, return a single empty string
  if content == "" then
    return { "" }
  end
  return vim.split(content, "\n", true)
end

-- Define your Python snippet
ls.add_snippets("python", {
  s("print", {
    t('print("'),
    f(last_yanked, {}), -- insert those lines here
    t('", '),
    f(last_yanked, {}), -- again for the second argument
    t(')'),
  }),
})
