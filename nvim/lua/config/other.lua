vim.cmd("set clipboard=unnamedplus")
vim.cmd("set shiftwidth=2")
vim.cmd("set autoindent")
vim.cmd("set tabstop=2")
vim.cmd("set expandtab")
vim.cmd("set relativenumber")
vim.cmd("set number")
vim.cmd("set nowrap")

os.setlocale("en_US.UTF-8", "time")

vim.opt.swapfile = false
vim.opt.autoread = true
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.cache/nvim/undo"
vim.opt.undofile = true

vim.opt.scrolloff = 8

vim.opt.ignorecase = true
vim.opt.smartcase = true
