local keymap = vim.keymap.set
local opts = { silent = true, noremap = true }

-- Navigation
keymap({ "n", "v", "o" }, "gh", "^", { silent = true, noremap = true, desc = "Beginning of line" })
keymap({ "n", "v", "o" }, "gl", "$", { silent = true, noremap = true, desc = "End of line" })

-- Scroll
vim.keymap.set({ "n", "i", "v", "t" }, "<A-s>", "<Esc>:normal! 5zh<CR>", opts) -- Scroll left
vim.keymap.set({ "n", "i", "v", "t" }, "<A-g>", "<Esc>:normal! 5zl<CR>", opts) -- Scroll right
vim.keymap.set({ "n", "i", "v", "t" }, "<A-d>", function() vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("5<C-e>", true, false, true), "n", false) end, opts) -- Scroll down
vim.keymap.set({ "n", "i", "v", "t" }, "<A-f>", function() vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("5<C-y>", true, false, true), "n", false) end, opts) -- Scroll up

-- Move highlighted text between lines
keymap("n", "<C-j>", ":m .+1<CR>==", opts) -- move line up
keymap("n", "<C-k>", ":m .-2<CR>==", opts) -- move line down
keymap("v", "<C-j>", ":m '>+1<CR>gv=gv", opts) -- move line up
keymap("v", "<C-k>", ":m '<-2<CR>gv=gv", opts) -- move line down
keymap("v", ">", ">gv", opts) -- indent right
keymap("v", "<", "<gv", opts) -- indent left

-- comment and paste below
keymap("n", "gy", "yygccp", { silent = true, remap = true, desc = "Copy and comment current line" })
keymap("v", "gy", "ygvgc`>o<Esc>gcc<Esc>p", { remap = true, desc = "Copy and comment selection" })

-- Undo/redo
keymap("n", "<S-u>", "<C-r>", opts)

-- Save C-s
keymap("i", "<C-s>", "<Esc><Cmd>w<CR>", opts)
keymap("n", "<C-s>", "<Cmd>w<CR>", opts)

-- search
keymap("n", "f", "*", opts) -- Search for word under cursor
keymap("n", "<C-f>", "/", opts) -- Search in normal mode
keymap("x", "<C-f>", "<Esc>/\\%V") -- Search visual selection

keymap("n", "<Esc>", ":noh<CR>", opts) -- Search highlight hide
keymap({ "n", "v" }, ",", "n", { noremap = true, desc = "Next search match" })
keymap({ "n", "v" }, ";", "N", { noremap = true, desc = "Previous search match" })

-- uppercase/lowercase
-- Moved to ../myPlugins/quickToggle.lua

-- Disable default behavior of 'd' to not copy to system clipboard. `d` is delete, `x` is cut.
-- Yank to system clipboard and "0. Cuts to "0. Pastes from "0.
keymap({ "n", "x" }, "d", '"0d', opts)
keymap({ "n", "x" }, "D", '"0D', opts)
keymap({ "n", "x" }, "c", '"0c', opts)
keymap({ "n", "x" }, "C", '"0C', opts)

keymap({ "n", "x" }, "p", '"0p', opts)
keymap({ "n", "x" }, "P", '"0P', opts)

-- Close buffer
-- Check out: ../myPlugins/bufferClosing.lua
-- keymap("n", "<C-w>", "<Cmd>bdelete<CR>", opts)
-- keymap("n", "<C-S-w>", "<Cmd>bdelete!<CR>", opts)
pcall(vim.api.nvim_del_keymap, "n", "<C-W><C-d>")
pcall(vim.api.nvim_del_keymap, "n", "<C-W>d")

-- Open buffer
keymap("n", "<C-t>", "<Cmd>:ene | startinsert<CR>", opts)

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
keymap("n", "<A-v>", "<Cmd>wincmd v<CR>", opts)
keymap("n", "<A-b>", "<Cmd>wincmd s<CR>", opts)

-- Close window
keymap("n", "<A-w>", "<Cmd>q<CR>", opts)

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
keymap("n", "<A-m>", "<Cmd>only<Cr>", opts)

-- Surround
keymap("v", "<Leader>(", "<Esc>`>a)<Esc>`<i(<Esc>", { silent = true, noremap = true, desc = "()" })
keymap("v", "<Leader>)", "<Esc>`>a)<Esc>`<i(<Esc>", { silent = true, noremap = true, desc = "()" })
keymap("v", "<Leader>[", "<Esc>`>a]<Esc>`<i[<Esc>", { silent = true, noremap = true, desc = "[]" })
keymap("v", "<Leader>]", "<Esc>`>a]<Esc>`<i[<Esc>", { silent = true, noremap = true, desc = "[]" })
keymap("v", "<Leader>{", "<Esc>`>a}<Esc>`<i{<Esc>", { silent = true, noremap = true, desc = "{}" })
keymap("v", "<Leader>}", "<Esc>`>a}<Esc>`<i{<Esc>", { silent = true, noremap = true, desc = "{}" })
keymap("v", "<Leader><", "<Esc>`>a><Esc>`<i<<Esc>", { silent = true, noremap = true, desc = "<>" })
keymap("v", "<Leader>>", "<Esc>`>a><Esc>`<i<<Esc>", { silent = true, noremap = true, desc = "<>" })
keymap("v", '<Leader>"', '<Esc>`>a"<Esc>`<i"<Esc>', { silent = true, noremap = true, desc = '""' })
keymap("v", "<Leader>'", "<Esc>`>a'<Esc>`<i'<Esc>", { silent = true, noremap = true, desc = "''" })
keymap("v", "<Leader>`", "<Esc>`>a`<Esc>`<i`<Esc>", { silent = true, noremap = true, desc = "``" })
keymap("v", "<Leader>$", "<Esc>`>a$<Esc>`<i$<Esc>", { silent = true, noremap = true, desc = "()" })
keymap("v", "<Leader>*", "<Esc>`>a*<Esc>`<i*<Esc>", { silent = true, noremap = true, desc = "**" })

-- delete words
keymap("i", "<A-BS>", "<C-W>", opts)
keymap("i", "<C-BS>", "<C-W>", opts)

-- messages
local function messages_close()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local name = vim.api.nvim_buf_get_name(buf)
		if name == "" and vim.api.nvim_buf_get_option(buf, "buftype") == "nofile" then
			vim.api.nvim_win_close(win, true)
			return
		end
	end
end

keymap("n", "<leader>m", "<Nop>", { silent = true, noremap = true, desc = "Messages" })
keymap("n", "<leader>mm", "<Cmd>messages<CR>", { silent = true, noremap = true, desc = "Open messages" })
keymap("n", "<leader>md", "<Cmd>messages clear<CR>", { silent = true, noremap = true, desc = "Delete messages" })
keymap("n", "<leader>mc", messages_close, { silent = true, noremap = true, desc = "Close messages" })
keymap("n", "<leader>my", "<Cmd>let @+ = execute('messages')<CR>", { silent = true, noremap = true, desc = "Yank messages" })

-- Entire file operations
local function yank_entire_file()
	local cursor_line = vim.api.nvim_win_get_cursor(0)
	vim.cmd("normal! ggVGy")
	vim.api.nvim_win_set_cursor(0, cursor_line)
end
keymap("n", "yae", yank_entire_file, { silent = true, noremap = true, desc = "Yank entire file" })
keymap("n", "dae", 'ggVG"0d', { silent = true, noremap = true, desc = "Delete entire file" })
keymap("n", "vae", "ggVG", { silent = true, noremap = true, desc = "Select entire file" })

keymap("n", "<leader>d", "<Cmd>lua vim.diagnostic.open_float()<CR>", { silent = true, noremap = true, desc = "Show diagnostics" })

-- Find and replace
local function visual_replace()
  local search = vim.fn.escape(vim.fn.input("Replace: "), [[\/]])
  if search == "" then
    return
  end

  local replace = vim.fn.escape(vim.fn.input("With: "), [[\/&]])
  if replace == "" then
    return
  end

  vim.cmd(string.format("'<,'>s/%s/%s/g", search, replace))
end

keymap("n", "<C-r>", "#*zz:s//", { silent = true, noremap = true, desc = "Replace" })
keymap("n", "<C-S-r>", "&", { silent = true, noremap = true, desc = "Repeat replace" }) -- Repeat last replace, if in visual replace in selection
keymap("v", "<C-r>", visual_replace, { noremap = true, desc = "Replace in selection" })
