-- The theme is set in nvim/lua/plugins/pywal16.lua
vim.cmd("hi CursorLineNr guifg=#ff966c")
vim.cmd("hi LineNr guifg=#ff966c")
vim.cmd("hi LineNrAbove guifg=#a66f59")
vim.cmd("hi LineNrBelow guifg=#a66f59")

vim.api.nvim_set_hl(0, "UfoFoldedBg", { bg = "#283457" })
vim.cmd("hi Folded guibg=#283457")

vim.opt.fillchars = { eob = " " }
