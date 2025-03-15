local keymap = vim.keymap.set
local opts = { silent = true, noremap = true }
local modes = { "n", "i", "v", "t", "o" }
local noimodes = { "n", "v", "o" }

local wk = require("which-key")

-- Navigation
keymap(noimodes, "gh", "^", opts)
keymap(noimodes, "gl", "$", opts)
wk.add({
	{ "gh", desc = "Beginning of line", mode = noimodes },
	{ "gl", desc = "End of line", mode = noimodes },
	{ "<Leader><Leader>", desc = "Find files", mode = noimodes },
})

keymap(noimodes, "<Leader><Leader>", ":Telescope find_files<CR>", opts)

-- Scroll
-- Vertical scroll is handled by neoscroll plugin
keymap(modes, "<A-s>", "5z<Left>", opts)
keymap(modes, "<A-g>", "5z<Right>", opts)

-- Move text
keymap("n", "<C-j>", ":m .+1<CR>==", opts) -- move line up(n)
keymap("n", "<C-k>", ":m .-2<CR>==", opts) -- move line down(n)
keymap("v", "<C-j>", ":m '>+1<CR>gv=gv", opts) -- move line up(v)
keymap("v", "<C-k>", ":m '<-2<CR>gv=gv", opts) -- move line down(v)

keymap("v", ">", ">gv", opts) -- indent right
keymap("v", "<", "<gv", opts) -- indent left

-- Undo/redo
keymap(noimodes, "<S-u>", "<C-r>", opts)

-- Save C-s
keymap("i", "<C-s>", "<Esc>:w<CR>", opts)

-- Search
keymap("n", "<C-f>", "*", opts)
keymap("v", "<C-f>", '"zy/<C-R>z<CR>', opts)

-- Uppercase/downcase
keymap("n", "<C-u>", "~", opts)
keymap("v", "<C-u>", "~", opts)

-- Chera highlight
keymap("n", "<Esc>", ":noh<CR>", { noremap = false, silent = true })

-- Disable default behavior of 'd' to not copy to clipboard
keymap("n", "d", '"0d', opts) -- Normal mode
keymap("v", "d", '"0d', opts) -- Visual mode
keymap("n", "D", '"0D', opts) -- Normal mode
keymap("v", "D", '"0D', opts) -- Visual mode
keymap("n", "x", '"0x', opts) -- Normal mode
keymap("v", "x", '"0x', opts) -- Visual mode

keymap("n", "p", '"0p', opts) -- Normal mode
keymap("v", "p", '"0p', opts) -- Visual mode
keymap("n", "P", '"0P', opts) -- Normal mode
keymap("v", "p", '"0P', opts) -- Visual mode

-- Paste from clipboard for neovide
keymap("n", "<C-S-v>", '"+p', opts)

-- Buffer close
keymap("n", "<C-W>", "<Cmd>bd!<Cr>", opts)
-- keymap("n", "<C-W>", "<Nop>", { noremap = true, silent = true })

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
keymap("n", "<A-w>", ":close<CR>", opts)

-- Move windows around
keymap("n", "<A-S-h>", ":wincmd H<CR>", opts)
keymap("n", "<A-S-j>", ":wincmd J<CR>", opts)
keymap("n", "<A-S-k>", ":wincmd K<CR>", opts)
keymap("n", "<A-S-l>", ":wincmd L<CR>", opts)

-- Resize windows
keymap("n", "<A-C-j>", ":wincmd +<CR>", opts)
keymap("n", "<A-C-k>", ":wincmd -<CR>", opts)
keymap("n", "<A-C-l>", ":wincmd ><CR>", opts)
keymap("n", "<A-C-h>", ":wincmd <<CR>", opts)
keymap("n", "<A-C-m>", ":wincmd o<CR>", opts)

-- Sentence navigation
keymap("n", "<A-n>", "(", opts)
keymap("n", "<A-m>", ")", opts)

-- Marks
keymap("n", "m", "`", opts)
keymap("v", "m", "`", opts)

keymap("n", "<C-m>", "m", opts)

keymap("n", "<Leader>m", ":Telescope marks<CR>", opts)
keymap("n", "<Leader>t", ":TodoTelescope<CR>", opts)

local function delete_mark_on_current_line()
	local current_line = vim.fn.line(".")
	local marks = "abcdefghijklmnopqrstuvwxyz123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789" -- Local marks to check
	local change = false

	for mark in marks:gmatch(".") do
		local pos = vim.fn.getpos("'" .. mark) -- Get the position of the mark
		if pos[2] == current_line then -- Check if the mark is on the current line
			vim.cmd("delmarks " .. mark)
			change = true
		end
	end
	if change then
		vim.cmd("redraw!")
	else
		vim.notify("No marks found on current line")
	end
end

keymap("n", "dm", delete_mark_on_current_line, opts)

-- Parentheses
keymap("v", "<leader>(", "<Esc>`<i(<Esc>`>la)<Esc>", opts)
keymap("v", "<leader>[", "<Esc>`<i[<Esc>`>la]<Esc>", opts)
keymap("v", "<leader>{", "<Esc>`<i{<Esc>`>la}<Esc>", opts)
keymap("v", '<leader>"', '<Esc>`<i"<Esc>`>la"<Esc>', opts)
keymap("v", "<leader>'", "<Esc>`<i'<Esc>`>la'<Esc>", opts)
keymap("v", "<leader>`", "<Esc>`<i`<Esc>`>la`<Esc>", opts)

-- Checkboxes
keymap("n", "<C-c>", ":lua require('toggle-checkbox').toggle()<CR>", opts)
keymap("i", "<C-c>", "<Esc>:lua require('toggle-checkbox').toggle()<CR>i", opts)

-- Obsidian
keymap("n", "<C-d>", ":DiaryModeToggle", opts)

keymap("i", "<A-BS>", "<C-W>", opts)
keymap("i", "<C-BS>", "<C-W>", opts) -- does not work. I think terminal eats it up.

function openOrSwitchTerm()
	-- Check if a terminal is already open in any window
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].buftype == "terminal" then
			vim.api.nvim_set_current_win(win) -- Switch to terminal window
			-- print("Terminal already open in another window")
			return
		end
	end
	-- Check if a terminal buffer exists
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[buf].buftype == "terminal" then
			vim.cmd("buffer " .. buf) -- Switch to existing terminal buffer
			-- print("Terminal already open in another buffer")
			return
		end
	end
	vim.cmd("terminal")
end

-- Correct way to set the keymap
keymap("n", "<A-t>", ":lua openOrSwitchTerm()<CR>", opts)
keymap("t", "<A-t>", "<C-\\><C-n>", opts)
keymap("t", "<Esc>", "<C-\\><C-n>", opts)

keymap("n", "<C-p>", ":CccPick<CR>", opts)
