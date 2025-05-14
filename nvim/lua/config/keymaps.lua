-- TODO: When searching for files use the <Leader>f_ keymap. <L>fb will open buffers. <L>ff will open files search, <L>fg will open git files search.
-- TODO: Add a grep keymap. <L>gb will grep buffers, <L>gc will grep cwd, <L>gg will grep git files.
-- TODO: Achieve this with telescope. Don'r reenvent the wheel.
local keymap = vim.keymap.set
local opts = { silent = true, noremap = true }
local modes = { "n", "i", "v", "t", "o" }
local noimodes = { "n", "v", "o" }

-- Navigation
keymap(noimodes, "gh", "^", { silent = true, noremap = true, desc = "Beginning of line" })
keymap(noimodes, "gl", "$", { silent = true, noremap = true, desc = "End of line" })

if pcall(require, "oil") then
  keymap("n", "<Leader>e", "<Cmd>Oil<CR>", opts)
else
  keymap("n", "<Leader>e", "<Cmd>e .<CR>", opts)
end

-- Scroll
-- Vertical scroll is handled by neoscroll plugin
keymap(modes, "<A-s>", "5z<Left>", opts)
keymap(modes, "<A-g>", "5z<Right>", opts)

-- Move highlighted text between lines
keymap("n", "<C-j>", ":m .+1<CR>==", opts)     -- move line up
keymap("n", "<C-k>", ":m .-2<CR>==", opts)     -- move line down
keymap("v", "<C-j>", ":m '>+1<CR>gv=gv", opts) -- move line up
keymap("v", "<C-k>", ":m '<-2<CR>gv=gv", opts) -- move line down
keymap("v", ">", ">gv", opts)                  -- indent right
keymap("v", "<", "<gv", opts)                  -- indent left

-- Comment comment and paste below
keymap("n", "gy", "yygccp", { silent = true, remap = true, desc = "Copy and comment current line" })
keymap("v", "gy", "ygvgcgv`><Esc>p", { remap = true, desc = "Copy and comment selection" })

-- Undo/redo
keymap(noimodes, "<S-u>", "<C-r>", opts)

-- Save C-s
keymap("i", "<C-s>", "<Esc><Cmd>w<CR>", opts)
keymap("n", "<C-s>", "<Cmd>w<CR>", opts)

-- search
keymap("n", "<C-f>", "*", opts)
keymap("v", "<C-f>", '"zy/<C-R>z<CR>', opts)
keymap("n", "f", "/", opts)
keymap("v", "f", "/", opts)
keymap("x", "/", "<Esc>/\\%V")                                       -- Search visual selection
keymap("n", "<Esc>", ":noh<CR>", { noremap = false, silent = true }) -- Search highlight hide
keymap("n", ",", "n", { remap = false, desc = "Next search match" })
keymap("n", ";", "N", { remap = false, desc = "Previous search match" })

-- uppercase/lowercase
keymap("n", "<C-u>", "~", opts)
keymap("v", "<C-u>", "~", opts)

-- Disable default behavior of 'd' to not copy to system clipboard
-- Yank to system clipboard and "0.
-- Cuts to "0.
-- Pastes from "0.
keymap("n", "d", '"0d', opts) -- Normal mode
keymap("v", "d", '"0d', opts) -- Visual mode
keymap("n", "D", '"0D', opts) -- Normal mode
keymap("v", "D", '"0D', opts) -- Visual mode
keymap("n", "x", '"0x', opts) -- Normal mode
keymap("v", "x", '"0x', opts) -- Visual mode
keymap("n", "c", '"0c', opts) -- Normal mode
keymap("v", "c", '"0c', opts) -- Visual mode
keymap("n", "C", '"0C', opts) -- Normal mode
keymap("v", "C", '"0C', opts) -- Visual mode

keymap("n", "p", '"0p', opts) -- Normal mode
keymap("v", "p", '"0p', opts) -- Visual mode
keymap("n", "P", '"0P', opts) -- Normal mode
keymap("v", "p", '"0P', opts) -- Visual mode

-- Paste from system clipboard
keymap("n", "<C-S-v>", '"+p', opts)
keymap("i", "<C-S-v>", '<Cmd>normal!"+pa<CR>', opts)
keymap("t", "<C-S-v>", '<C-\\><C-N>"+pa', opts)

-- Close buffer
keymap("n", "<C-w>", "<Cmd>bd!<Cr>", opts)
pcall(vim.api.nvim_del_keymap, "n", "<C-W><C-d>")
pcall(vim.api.nvim_del_keymap, "n", "<C-W>d")

-- Open buffer
keymap("n", "<C-t>", "<Cmd>new<Cr>", opts)

-- Windows
-- Navigate between windows
keymap("n", "<A-h>", ":wincmd h<CR>", opts)
keymap("n", "<A-j>", ":wincmd j<CR>", opts)
keymap("n", "<A-k>", ":wincmd k<CR>", opts)
keymap("n", "<A-l>", ":wincmd l<CR>", opts)

keymap("t", "<A-h>", [[<C-\><C-n>:wincmd h<CR>]], opts)
keymap("t", "<A-j>", [[<C-\><C-n>:wincmd j<CR>]], opts)
keymap("t", "<A-k>", [[<C-\><C-n>:wincmd k<CR>]], opts)
keymap("t", "<A-l>", [[<C-\><C-n>:wincmd l<CR>]], opts)

-- Create new windows
keymap("n", "<A-v>", ":wincmd v<CR>", opts)
keymap("n", "<A-b>", ":wincmd s<CR>", opts)

-- Close window
keymap("n", "<A-w>", "<Cmd>w! | close<CR>", opts)

-- Move windows around
if pcall(require, "winshift") then
  keymap("n", "<A-S-h>", "<Cmd>WinShift left<CR>", opts)
  keymap("n", "<A-S-j>", "<Cmd>WinShift down<CR>", opts)
  keymap("n", "<A-S-k>", "<Cmd>WinShift up<CR>", opts)
  keymap("n", "<A-S-l>", "<Cmd>WinShift right<CR>", opts)
else
  keymap("n", "<A-S-h>", "<Cmd>wincmd H<CR>", opts)
  keymap("n", "<A-S-j>", "<Cmd>wincmd J<CR>", opts)
  keymap("n", "<A-S-k>", "<Cmd>wincmd K<CR>", opts)
  keymap("n", "<A-S-l>", "<Cmd>wincmd L<CR>", opts)
end

-- Resize windows
keymap("n", "<A-C-j>", ":wincmd +<CR>", opts)
keymap("n", "<A-C-k>", ":wincmd -<CR>", opts)
keymap("n", "<A-C-l>", ":wincmd ><CR>", opts)
keymap("n", "<A-C-h>", ":wincmd <<CR>", opts)
keymap("n", "<A-C-m>", ":wincmd o<CR>", opts)
keymap("n", "<A-=>", ":wincmd =<CR>", opts)

-- Parentheses
keymap("v", "<leader>(", "<Esc>`<i(<Esc>`>la)<Esc>", { silent = true, noremap = true, desc = "()" })
keymap("v", "<leader>)", "<Esc>`<i(<Esc>`>la)<Esc>", { silent = true, noremap = true, desc = "()" })
keymap("v", "<leader>[", "<Esc>`<i[<Esc>`>la]<Esc>", { silent = true, noremap = true, desc = "[]" })
keymap("v", "<leader>]", "<Esc>`<i[<Esc>`>la]<Esc>", { silent = true, noremap = true, desc = "[]" })
keymap("v", "<leader>{", "<Esc>`<i{<Esc>`>la}<Esc>", { silent = true, noremap = true, desc = "{}" })
keymap("v", "<leader>}", "<Esc>`<i{<Esc>`>la}<Esc>", { silent = true, noremap = true, desc = "{}" })
keymap("v", "<leader><", "<Esc>`<i<<Esc>`>la><Esc>", { silent = true, noremap = true, desc = "<>" })
keymap("v", "<leader>>", "<Esc>`<i<<Esc>`>la><Esc>", { silent = true, noremap = true, desc = "<>" })
keymap("v", '<leader>"', '<Esc>`<i"<Esc>`>la"<Esc>', { silent = true, noremap = true, desc = '""' })
keymap("v", "<leader>'", "<Esc>`<i'<Esc>`>la'<Esc>", { silent = true, noremap = true, desc = "''" })
keymap("v", "<leader>`", "<Esc>`<i`<Esc>`>la`<Esc>", { silent = true, noremap = true, desc = "``" })

keymap("i", "<A-BS>", "<C-W>", opts)
keymap("i", "<C-BS>", "<C-W>", opts) -- does not work. I think terminal eats it up.

keymap("n", "<C-p>", ":CccPick<CR>", opts)

-- dashboard
keymap("n", "<leader>h", function()
  require("snacks.dashboard").open()
end, { desc = "Open Snacks Dashboard" })
