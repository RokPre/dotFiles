--TODO: Check if which-key is available.
local keymap = vim.keymap.set
local opts = { silent = true, noremap = true }
local modes = { "n", "i", "v", "t", "o" }
local noimodes = { "n", "v", "o" }

local wk = require("which-key")

wk.add({
	{ "gh", desc = "Beginning of line", mode = noimodes },
	{ "gl", desc = "End of line", mode = noimodes },
	{ "<Leader><Leader>", desc = "Find files", mode = noimodes },
	{ "<Leader>u", desc = "Undo tree", mode = noimodes },
	{ "<Leader>g", desc = "Git files", mode = noimodes },
	{ "<Leader>b", desc = "List buffers", mode = noimodes },
	-- { "<Leader>p", desc = "Project manager", mode = noimodes },
	-- { "<Leader>pp", desc = "View projects", mode = noimodes },
	-- { "<Leader>pi", desc = "Add to ignore", mode = noimodes },
	-- { "<Leader>pr", desc = "Remove from ignore", mode = noimodes },
	-- { "<Leader>pv", desc = "View ignore list", mode = noimodes },
	{ "<Leader>cwd", desc = "Set cwd", mode = noimodes },
	{ "<Leader>t", desc = "Todo list", mode = noimodes },
	{ "<Leader>tt", desc = "Current buffer", mode = noimodes },
	{ "<Leader>tb", desc = "Open buffers", mode = noimodes },
	{ "<Leader>tc", desc = "Cwd", mode = noimodes },
	{ "<Leader>tg", desc = "Current git repositorie", mode = noimodes },
	{ "<Leader>th", desc = "Home directory", mode = noimodes },
	{ "<Leader>ts", desc = "System files", mode = noimodes },
	{ "<Leader>ti", desc = "Add to ignore list", mode = noimodes },
	{ "<Leader>tr", desc = "Remove from ignore list", mode = noimodes },
	{ "<Leader>tv", desc = "View ignore list", mode = noimodes },
	{ "<Leader>s", desc = "Session manager", mode = noimodes },
	{ "<Leader>ss", desc = "Save session", mode = noimodes },
	{ "<Leader>sl", desc = "Load session", mode = noimodes },
	{ "<Leader>sa", desc = "All sessions", mode = noimodes },
	{ "<Leader>sc", desc = "Clear sessions", mode = noimodes },
})

-- Navigation
keymap(noimodes, "gh", "^", opts)
keymap(noimodes, "gl", "$", opts)

-- Folder and file navigation
local builtin = require("telescope.builtin")
local function safe_git_files()
	local current_dir = vim.fn.getcwd()
	local buffer_dir = vim.fn.expand("%:p:h")
	local git_dir = vim.fn.finddir(".git", buffer_dir .. ";")
	git_dir = git_dir:sub(0, -5)

	if git_dir == "" then -- Empty string means no .git directory found
		print("Showing dir files for: " .. buffer_dir)
		vim.cmd("cd " .. buffer_dir)
		builtin.find_files()
		vim.cmd("cd " .. current_dir)
	else
		print("Showing git files for: " .. git_dir)
		vim.cmd("cd " .. git_dir)
		builtin.git_files()
		vim.cmd("cd " .. current_dir)
	end
end
keymap(noimodes, "<Leader><Leader>", ":Telescope find_files<CR>", opts)
keymap(noimodes, "<Leader>g", safe_git_files, opts)
keymap(noimodes, "<Leader>b", builtin.buffers, opts)
keymap(noimodes, "<Leader>cwd", function()
	vim.cmd("cd " .. vim.fn.expand("%:p:h"))
	print("CWD: " .. vim.fn.expand("%:p:h"))
end, { silent = false })

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
keymap("n", "<C-j>", ":m .+1<CR>==", opts) -- move line up(n)
keymap("n", "<C-k>", ":m .-2<CR>==", opts) -- move line down(n)
keymap("v", "<C-j>", ":m '>+1<CR>gv=gv", opts) -- move line up(v)
keymap("v", "<C-k>", ":m '<-2<CR>gv=gv", opts) -- move line down(v)
keymap("v", ">", ">gv", opts) -- indent right
keymap("v", "<", "<gv", opts) -- indent left

-- Undo/redo
keymap(noimodes, "<S-u>", "<C-r>", opts)

-- Save C-s
keymap("i", "<C-s>", "<Esc><Cmd>w<CR>", opts)
keymap("n", "<C-s>", "<Cmd>w<CR>", opts)

-- Search
keymap("n", "<C-f>", "*", opts)
keymap("v", "<C-f>", '"zy/<C-R>z<CR>', opts)

-- Uppercase/downcase
keymap("n", "<C-u>", "~", opts)
keymap("v", "<C-u>", "~", opts)

-- Search highlight hide
keymap("n", "<Esc>", ":noh<CR>", { noremap = false, silent = true })

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
vim.api.nvim_del_keymap("n", "<C-W><C-d>")
vim.api.nvim_del_keymap("n", "<C-W>d")

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

-- Sentence navigation
keymap("n", "<A-n>", "(", opts)
keymap("n", "<A-m>", ")", opts)

-- Parentheses
keymap("v", "<leader>(", "<Esc>`<i(<Esc>`>la)<Esc>", opts)
keymap("v", "<leader>)", "<Esc>`<i(<Esc>`>la)<Esc>", opts)
keymap("v", "<leader>[", "<Esc>`<i[<Esc>`>la]<Esc>", opts)
keymap("v", "<leader>]", "<Esc>`<i[<Esc>`>la]<Esc>", opts)
keymap("v", "<leader>{", "<Esc>`<i{<Esc>`>la}<Esc>", opts)
keymap("v", "<leader>}", "<Esc>`<i{<Esc>`>la}<Esc>", opts)
keymap("v", '<leader>"', '<Esc>`<i"<Esc>`>la"<Esc>', opts)
keymap("v", "<leader>'", "<Esc>`<i'<Esc>`>la'<Esc>", opts)
keymap("v", "<leader>`", "<Esc>`<i`<Esc>`>la`<Esc>", opts)

keymap("i", "<A-BS>", "<C-W>", opts)
keymap("i", "<C-BS>", "<C-W>", opts) -- does not work. I think terminal eats it up.

keymap("n", "<C-p>", ":CccPick<CR>", opts)

-- Folding folding folds
vim.api.nvim_set_keymap("n", "h", "", {
	noremap = true,
	callback = function()
		local col = vim.api.nvim_win_get_cursor(0)[2]
		local line = vim.fn.getline(".")
		local first_non_blank = #vim.fn.matchstr(line, "^\\s*")
		if col <= first_non_blank then
			vim.cmd("normal! zc ")
		else
			vim.api.nvim_feedkeys("h", "n", false)
		end
	end,
})

-- dashboard
keymap("n", "<leader>d", function()
	require("snacks.dashboard").open()
end, { desc = "Open Snacks Dashboard" })

-- Codeblocks
keymap("n", "<A-C-c>", "<Cmd>insert``<Cr>", { remap = true })
keymap("i", "<A-C-c>", "``", { remap = true })
keymap("v", "<A-C-c>", "``", { remap = true })

keymap("n", "<A-S-c>", "<Cmd>insert```\n```<Cr>", { remap = true })
keymap("i", "<A-S-c>", "```\n```", { remap = true })
keymap("v", "<A-S-c>", "```\n```", { remap = true })
