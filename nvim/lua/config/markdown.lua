local ls = require("luasnip")
local s  = ls.snippet
local t  = ls.text_node
local i = ls.insert_node
local f  = ls.function_node


ls.add_snippets("markdown", {
    s("mk", {
        t('$'),
        i(1),
        t('$')
    }),
})

ls.add_snippets("markdown", {
    s("dm", {
        t({'$$$', ""}),
        i(1),
        t({"", '$$$'}),
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
    vim.keymap.set("i", "<A-C-c>", "``", { remap = true })
    vim.keymap.set("v", "<A-C-c>", "``", { remap = true })
    vim.keymap.set("i", "<A-S-c>", "```\n```", { remap = true })
    vim.keymap.set("v", "<A-S-c>", "```\n```", { remap = true })
  end,
})


local ts_utils = require('nvim-treesitter.ts_utils')

function is_in_latex_block()
  local node = ts_utils.get_node_at_cursor()
  while node do
    if node:type() == 'fenced_code_block' then
      local lang_node = node:field('info')[1]
      if lang_node and vim.treesitter.query.get_node_text(lang_node, 0) == 'latex' then
        return true
      end
    end
    node = node:parent()
  end
  return false
end
