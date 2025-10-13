local keymap = vim.keymap.set
local opts = { silent = true, noremap = true }

-- Navigation
-- This was moved to ufo as it also works as a folding keymap ../plugins/ufo.lua
-- keymap("v", "gh", "^", { silent = true, noremap = true, desc = "Beginning of line" })
-- keymap("v", "gl", "$", { silent = true, noremap = true, desc = "End of line" })
-- keymap("o", "gh", "^", { silent = true, noremap = true, desc = "Beginning of line" })
-- keymap("o", "gl", "$", { silent = true, noremap = true, desc = "End of line" })

-- Scroll
-- Vertical scroll is handled by neoscroll plugin
keymap({ "n", "i", "v", "t" }, "<A-s>", "<Cmd>5z<Left><CR>", opts)
keymap({ "n", "i", "v", "t" }, "<A-g>", "<Cmd>5z<Right><CR>", opts)

-- Move highlighted text between lines
keymap("n", "<C-j>", ":m .+1<CR>==", opts)     -- move line up
keymap("n", "<C-k>", ":m .-2<CR>==", opts)     -- move line down
keymap("v", "<C-j>", ":m '>+1<CR>gv=gv", opts) -- move line up
keymap("v", "<C-k>", ":m '<-2<CR>gv=gv", opts) -- move line down
keymap("v", ">", ">gv", opts)                  -- indent right
keymap("v", "<", "<gv", opts)                  -- indent left

-- Comment comment and paste below
keymap("n", "gy", "yygccp", { silent = true, remap = true, desc = "Copy and comment current line" })
keymap("v", "gy", "ygvgc`>o<Esc>gcco<Esc>p", { remap = true, desc = "Copy and comment selection" })

-- Undo/redo
keymap("n", "<S-u>", "<C-r>", opts)

-- Save C-s
keymap("i", "<C-s>", "<Esc><Cmd>w<CR>", opts)
keymap("n", "<C-s>", "<Cmd>w<CR>", opts)

-- search
keymap("n", "<C-f>", "*", opts)
keymap("v", "<C-f>", '"zy/<C-R>z<CR>', opts)
keymap("n", "f", "/", opts)
keymap("v", "f", "/", opts)
keymap("x", "/", "<Esc>/\\%V")         -- Search visual selection
keymap("n", "<Esc>", ":noh<CR>", opts) -- Search highlight hide
keymap({ "n", "v" }, ",", "n", { noremap = true, desc = "Next search match" })
keymap({ "n", "v" }, ";", "N", { noremap = true, desc = "Previous search match" })

-- uppercase/lowercase
-- Moved to ../myPlugins/quickToggle.lua

-- Disable default behavior of 'd' to not copy to system clipboard
-- Yank to system clipboard and "0. Cuts to "0. Pastes from "0.
keymap({ "n", "v" }, "d", '"0d', opts)
keymap({ "n", "v" }, "D", '"0D', opts)
keymap({ "n", "v" }, "x", '"0x', opts)
keymap({ "n", "v" }, "c", '"0c', opts)
keymap({ "n", "v" }, "C", '"0C', opts)

keymap({ "n", "v" }, "p", '"0p', opts)
keymap({ "n", "v" }, "P", '"0P', opts)

-- Close buffer
-- This has been moved to: ../myPlugins/bufferClosing.lua

-- Open buffer
keymap("n", "<C-t>", "<Cmd>tabnew<CR>", opts)

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
keymap("n", "<leader>my", "<Cmd>let @+ = execute('messages')<CR>",
  { silent = true, noremap = true, desc = "Yank messages" })

keymap("n", "yae", "<Cmd>%y<Cr>", { silent = true, noremap = true, desc = "Yank entire file" })
keymap("n", "dae", "<Cmd>%d<Cr>", { silent = true, noremap = true, desc = "Delete entire file" })
keymap("n", "vae", "ggVG", { silent = true, noremap = true, desc = "Select entire file" })
