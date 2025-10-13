local keymap = vim.keymap.set
local opts = { silent = true, noremap = true }

local function openOrSwitchTerm()
  -- Check if a terminal is already open in any window, switch to that window
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == "terminal" then
      vim.api.nvim_set_current_win(win) -- Switch to terminal window
      -- print("Terminal already open in another window")
      return
    end
  end
  -- Check if a terminal buffer exists, switch to that buffer
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == "terminal" then
      vim.cmd("buffer " .. buf) -- Switch to existing terminal buffer
      -- print("Terminal already open in another buffer")
      return
    end
  end
  -- Open up new terminal if none exists
  vim.cmd("terminal")
end

-- Correct way to set the keymap
keymap("n", "<A-t>", openOrSwitchTerm, opts)
keymap("t", "<A-t>", "<C-\\><C-n>", opts)
keymap("t", "<Esc>", "<C-\\><C-n>", opts)
