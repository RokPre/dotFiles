local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

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
local function today() return link_for_day(0, "today") end
local function danes() return link_for_day(0, "danes") end
local function yesterday() return link_for_day(-86400) end
local function uceraj() return link_for_day(-86400) end
local function tomorrow() return link_for_day(86400) end
local function jutri() return link_for_day(86400) end

ls.add_snippets("markdown", {
  -- Inline math
  s({ trig = "mk", snippetType = "autosnippet", wordTrig = true }, {
    t('$'), i(1), t('$'),
  }),

  -- Display math
  s({ trig = "dm", snippetType = "autosnippet", wordTrig = true }, {
    t({ "$$", "" }),
    i(1),
    t({ "", "$$" }),
  }),

  -- Inline code
  s({ trig = "code", wordTrig = true }, {
    t("`"), i(1), t("`"),
  }),

  -- Code block
  s({ trig = "codeblock", wordTrig = true }, {
    t({ "```" }), i(1), t({ "", "" }), i(2), t({ "", "```" }),
  }),

  -- Date links
  s({ trig = "today", snippetType = "autosnippet", wordTrig = true }, { f(today) }),
  s({ trig = "danes", snippetType = "autosnippet", wordTrig = true }, { f(danes) }),
  s({ trig = "yesterday", snippetType = "autosnippet", wordTrig = true }, { f(yesterday) }),
  s({ trig = "uceraj", snippetType = "autosnippet", wordTrig = true }, { f(uceraj) }),
  s({ trig = "tomorrow", snippetType = "autosnippet", wordTrig = true }, { f(tomorrow) }),
  s({ trig = "jutri", snippetType = "autosnippet", wordTrig = true }, { f(jutri) }),
})

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

vim.filetype.add({
  extension = {
    md = "markdown",
  },
})

local opts = { silent = true, noremap = true, buffer = true }
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.keymap.set("n", "<C-c>", check_box, opts)
    vim.keymap.set("n", "<C-A-h>", "<Cmd>bprev<Cr>", opts)
    vim.keymap.set("n", "<C-A-l>", "<Cmd>bnext<Cr>", opts)
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = false

    -- Codeblocks
    vim.keymap.set("i", "<C-A-c>", "``<Esc>h", { remap = true })
    vim.keymap.set("v", "<C-A-c>", "``<Esc>h", { remap = true })
    vim.keymap.set("i", "<C-S-c>", "```\n```", { remap = true })
    vim.keymap.set("v", "<C-S-c>", "```\n```", { remap = true })
  end,
})

local ts_utils = require("nvim-treesitter.ts_utils")

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

-- Snippeti aktivni samo znotraj math
ls.add_snippets("markdown", {
  s({ trig = "fr", wordTrig = true, condition = in_math, snippetType = "autosnippet" },
    fmt("\\frac{{{}}}{{{}}}", { i(1), i(2) })
  ),
  s({ trig = "sq", wordTrig = true, condition = in_math, snippetType = "autosnippet" },
    fmt("\\sqrt{{{}}}", { i(1) })
  ),
  s({ trig = "al", wordTrig = true, condition = in_math, snippetType = "autosnippet" },
    t("\\alpha")
  ),
  s({ trig = "be", wordTrig = true, condition = in_math, snippetType = "autosnippet" },
    t("\\beta")
  ),
  s({ trig = "plus", wordTrig = true, condition = in_math, snippetType = "autosnippet" },
    t("+")
  ),
  s({ trig = "minus", wordTrig = true, condition = in_math, snippetType = "autosnippet" },
    t("-")
  ),
  s({ trig = "je", wordTrig = true, condition = in_math, snippetType = "autosnippet" },
    t("=")
  ),
  s({ trig = "nic", wordTrig = true, condition = in_math, snippetType = "autosnippet" },
    t("0")
  ),
  s({ trig = "ne", wordTrig = true, condition = in_math, snippetType = "autosnippet" },
    t("\\ne")
  ),
  s({ trig = "vec", wordTrig = true, condition = in_math, snippetType = "autosnippet" },
    t("\\gt")
  ),
  s({ trig = "manj", wordTrig = true, condition = in_math, snippetType = "autosnippet" },
    t("\\ls")
  ),
  s({ trig = "torej", wordTrig = true, condition = in_math, snippetType = "autosnippet" },
    t("\\Rightarrow")
  ),
  s({ trig = "Ra", wordTrig = true, condition = in_math, snippetType = "autosnippet" },
    t("\\Rightarrow")
  ),
  s({ trig = "ra", wordTrig = true, condition = in_math, snippetType = "autosnippet" },
    t("\\rightarrow")
  ),
  s({ trig = "La", wordTrig = true, condition = in_math, snippetType = "autosnippet" },
    t("\\Leftarrow")
  ),
  s({ trig = "la", wordTrig = true, condition = in_math, snippetType = "autosnippet" },
    t("\\Leftarrow")
  ),
  s({ trig = "tedaj", wordTrig = true, condition = in_math, snippetType = "autosnippet" },
    t("\\Leftrightarrow")
  ),
})
