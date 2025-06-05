local function open_split_float()
  -- Create a new tabpage to isolate the layout (optional but clean)
  vim.cmd("tabnew")

  -- Create the buffer for the float and open the outer window
  local float_buf = vim.api.nvim_create_buf(false, true)
  local float_win = vim.api.nvim_open_win(float_buf, true, {
    relative = "editor",
    width = 80,
    height = 20,
    row = 5,
    col = 10,
    style = "minimal",
    border = "rounded",
  })

  -- Inside the float, split and set buffers
  vim.cmd("vsplit")

  -- Create two new buffers
  local buf1 = vim.api.nvim_create_buf(false, true)
  local buf2 = vim.api.nvim_create_buf(false, true)

  -- Add content
  vim.api.nvim_buf_set_lines(buf1, 0, -1, false, { "Left buffer" })
  vim.api.nvim_buf_set_lines(buf2, 0, -1, false, { "Right buffer" })

  -- Assign buffers to the split windows
  local wins = vim.api.nvim_tabpage_list_wins(0)
  vim.api.nvim_win_set_buf(wins[1], buf1)
  vim.api.nvim_win_set_buf(wins[2], buf2)

  -- Optional: make both windows non-editable and clean
  for _, win in ipairs(wins) do
    vim.api.nvim_win_set_option(win, "number", false)
    vim.api.nvim_win_set_option(win, "relativenumber", false)
  end
end

open_split_float()
