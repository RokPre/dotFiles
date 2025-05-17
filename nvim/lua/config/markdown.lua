-- TODO: When inside a math block ($, $$$) use the same snippets as nvim/lua/config/latex.lua
local ls = require("luasnip")
local s  = ls.snippet
local t  = ls.text_node
local i  = ls.insert_node
local f  = ls.function_node


ls.add_snippets("markdown", {
  s({ trig = "mk", snippetType = "autosnippet", wordTrig = true }, {
    t('$'),
    i(1),
    t('$')
  }),
})

ls.add_snippets("markdown", {
  s({ trig = "dm", snippetType = "autosnippet", wordTrig = true }, {
    t({ '$$$', "" }),
    i(1),
    t({ "", '$$$' }),
  }),
})

local opts = { silent = true, noremap = true, buffer = true }
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.keymap.set("n", "<C-c>", "<Cmd>ObsidianToggleCheckbox<CR>", opts)
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


local ts_utils = require('nvim-treesitter.ts_utils')
