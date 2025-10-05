local keymap = vim.keymap.set

local the_file_path = nil

local function copy_file_path()
  the_file_path = vim.api.nvim_buf_get_name(0)
  the_file_path = the_file_path:gsub(os.getenv("HOME"), "~")
  vim.fn.setreg('+', the_file_path)
  vim.fn.setreg('"', the_file_path)
end

local function paste_absolute_path()
  if not the_file_path or the_file_path == "" then
    vim.notify("No file path to paste")
    return
  end
  vim.api.nvim_buf_set_lines(
    vim.api.nvim_get_current_buf(),
    vim.api.nvim_win_get_cursor(0)[1] - 1,
    vim.api.nvim_win_get_cursor(0)[1],
    false,
    the_file_path
  )
end

local function paste_markdown_link()
  if not the_file_path or the_file_path == "" then
    vim.notify("No file path to paste")
    return
  end

  local file_name = vim.fn.fnamemodify(the_file_path, ":t:r")
  local link = string.format("(%s)[%s]", file_name, the_file_path)

  vim.api.nvim_buf_set_lines(
    vim.api.nvim_get_current_buf(),
    vim.api.nvim_win_get_cursor(0)[1] - 1,
    vim.api.nvim_win_get_cursor(0)[1],
    false,
    { link }
  )
end


local function embed_markdown_link()
  if not the_file_path or the_file_path == "" then
    vim.notify("No file path to paste")
    return
  end

  local file_name = vim.fn.fnamemodify(the_file_path, ":t:r")
  local link = string.format("!(%s)[%s]", file_name, the_file_path)

  vim.api.nvim_buf_set_lines(
    vim.api.nvim_get_current_buf(),
    vim.api.nvim_win_get_cursor(0)[1] - 1,
    vim.api.nvim_win_get_cursor(0)[1],
    false,
    { link }
  )
end

local function paste_obsidian_link()
  if not the_file_path or the_file_path == "" then
    vim.notify("No file path to paste")
    return
  end

  local file_name = vim.fn.fnamemodify(the_file_path, ":t:r")
  local link = string.format("[[%s]]", file_name)

  vim.api.nvim_buf_set_lines(
    vim.api.nvim_get_current_buf(),
    vim.api.nvim_win_get_cursor(0)[1] - 1,
    vim.api.nvim_win_get_cursor(0)[1],
    false,
    { link }
  )
end

local function embed_obsidian_link()
  if not the_file_path or the_file_path == "" then
    vim.notify("No file path to paste")
    return
  end

  local file_name = vim.fn.fnamemodify(the_file_path, ":t:r")
  local link = string.format("![[%s]]", file_name)

  vim.api.nvim_buf_set_lines(
    vim.api.nvim_get_current_buf(),
    vim.api.nvim_win_get_cursor(0)[1] - 1,
    vim.api.nvim_win_get_cursor(0)[1],
    false,
    { link }
  )
end

local function paste_relative_path()
  if not the_file_path or the_file_path == "" then
    vim.notify("No file path to paste")
    return
  end

  local current_file_path = vim.api.nvim_buf_get_name(0)
  local parent_folder = vim.fn.fnamemodify(current_file_path, ":p:h")
  local abs_the_file_path = vim.fn.fnamemodify(the_file_path, ":p")

  -- vim.print("abs the file path", abs_the_file_path)
  -- vim.print("current file path", current_file_path)

  -- climb upwards until we either find a parent inside abs_the_file_path or reach root
  local found = nil
  local link = ""
  while parent_folder ~= "/" and parent_folder ~= "" do
    if vim.startswith(abs_the_file_path, parent_folder) then
      found = parent_folder
      break
    end
    parent_folder = vim.fn.fnamemodify(parent_folder, ":h")
    link = link .. "../"
  end

  if found then
    -- now you could cut the common prefix and build a relative path
    local rel = abs_the_file_path:sub(#found + 2) -- +2 to skip trailing "/"
    link = link .. rel
    -- vim.print("Relative part:", rel)
    -- vim.print("Relative part:", link)
  else
    vim.notify("No common parent folder found")
    -- Fallback to absolute path
    vim.api.nvim_buf_set_lines(
      vim.api.nvim_get_current_buf(),
      vim.api.nvim_win_get_cursor(0)[1] - 1,
      vim.api.nvim_win_get_cursor(0)[1],
      false,
      { abs_the_file_path }
    )
    return
  end

  vim.api.nvim_buf_set_lines(
    vim.api.nvim_get_current_buf(),
    vim.api.nvim_win_get_cursor(0)[1] - 1,
    vim.api.nvim_win_get_cursor(0)[1],
    false,
    { link }
  )
end

keymap("n", "<leader>l", "<Nop>", { desc = "Links" })
keymap("n", "<leader>la", paste_absolute_path, { desc = "Paste absolute path" })
keymap("n", "<leader>lm", paste_markdown_link, { desc = "Paste markdown link" })
keymap("n", "<leader>lM", embed_markdown_link, { desc = "Embed markdown link" })
keymap("n", "<leader>lo", paste_obsidian_link, { desc = "Paste obsidian link" })
keymap("n", "<leader>lo", embed_obsidian_link, { desc = "Embed obsidian link" })
keymap("n", "<leader>lr", paste_relative_path, { desc = "Paste relative path" })
keymap("n", "<leader>ly", copy_file_path, { desc = "Copy file path" })
