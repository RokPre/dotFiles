vim.opt.clipboard = "unnamedplus"
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.wrap = false

os.setlocale("en_US.UTF-8", "time")

vim.opt.autoread = true -- automatically read file when changed outside of Vim
vim.opt.backup = false
vim.opt.ignorecase = true
vim.opt.scrolloff = 8
vim.opt.smartcase = true
vim.opt.swapfile = false
vim.opt.undodir = os.getenv("HOME") .. "/.cache/nvim/undo"
vim.opt.undofile = true

vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
