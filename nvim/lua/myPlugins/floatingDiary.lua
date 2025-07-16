local float_win = nil
local float_bufs = {}
local float_bufs_set = {}
local float_augroup = nil
local float_setup_augroup = nil
local SEARCH_STRING_FOR_CURSOR_POS = "___"

local function add_buf(buf)
  if not float_bufs_set[buf] then
    float_bufs[#float_bufs + 1] = buf
    float_bufs_set[buf] = true
  end
end

local function setup_obsidian_buffer(buf)
  if not (float_win and vim.api.nvim_win_is_valid(float_win)) then
    vim.notify("Floating diary is not enabled", vim.log.levels.WARN)
    return
  end

  vim.api.nvim_win_set_buf(float_win, buf)

  -- Hides the buffer from the bufferline
  vim.api.nvim_set_option_value("buflisted", false, { buf = buf })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })

  pcall(function()
    require("bufferline.ui").refresh()
  end)

  vim.api.nvim_set_current_win(float_win)

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  for index, line in ipairs(lines) do
    local ok, found = pcall(function()
      return line:find(SEARCH_STRING_FOR_CURSOR_POS)
    end)

    if ok and found then
      local row = index
      vim.api.nvim_win_set_cursor(float_win, { row, 0 })
      break
    end
  end
end

local function enable_floating_diary()
  local total_height = vim.o.lines
  local total_width = vim.o.columns
  local height = math.floor(total_height * 0.8)
  local ideal_width = 85
  local width = total_width >= ideal_width and ideal_width or math.floor(total_width * 0.8)
  local row = math.floor((total_height - height) / 2)
  local col = math.floor((total_width - width) / 2)

  local float_buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_set_option_value("buflisted", false, { buf = float_buf })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = float_buf })

  add_buf(float_buf)

  local win = vim.api.nvim_open_win(float_buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })

  if not win then
    vim.notify("Error opening floaring window", vim.log.levels.ERROR)
    return
  end

  float_win = win

  if float_augroup then
    pcall(function()
      vim.api.nvim_del_augroup_by_id(float_augroup)
    end)
  end
  float_augroup = vim.api.nvim_create_augroup("FloatingDiaryGroup", { clear = true })

  vim.api.nvim_create_autocmd("BufEnter", {
    group = float_augroup,
    callback = function()
      if not (float_win and vim.api.nvim_win_is_valid(float_win)) then return end
      local buf = vim.api.nvim_win_get_buf(float_win)
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_set_option_value("buflisted", false, { buf = buf })
        vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })

        pcall(function()
          require("bufferline.ui").refresh()
        end)
        add_buf(buf)
      end
    end,
  })

  vim.schedule(function()
    if not (float_win and vim.api.nvim_win_is_valid(float_win)) then return end
    vim.api.nvim_win_call(float_win, function()
      vim.cmd("ObsidianToday")
      float_setup_augroup = vim.api.nvim_create_augroup("FloatSetupGroup", { clear = true })
      vim.api.nvim_create_autocmd("BufEnter", {
        group = float_setup_augroup,
        callback = function()
          local current_buf = vim.api.nvim_get_current_buf()
          add_buf(current_buf)
          setup_obsidian_buffer(current_buf)
          vim.api.nvim_del_augroup_by_id(float_setup_augroup)
        end
      })
    end)
  end)
end

local function disable_floating_diary()
  -- Close tracked buffers
  for _, buf in ipairs(float_bufs) do
    if vim.api.nvim_buf_is_valid(buf) then
      if vim.api.nvim_buf_get_name(0) ~= "" then
        vim.api.nvim_buf_call(buf, function() vim.cmd("write") end)
      end
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
  float_bufs = {}
  float_bufs_set = {}
  if float_augroup then
    pcall(function()
      vim.api.nvim_del_augroup_by_id(float_augroup)
    end)
  end
  if float_win and vim.api.nvim_win_is_valid(float_win) then
    vim.api.nvim_win_close(float_win, true)
  end
  float_win = nil
end

function toggle_split_float()
  local ok, _ = pcall(require, "obsidian")
  if not ok then
    vim.notify("Obsidian is not installed", vim.log.levels.ERROR)
    return
  end

  if float_win and vim.api.nvim_win_is_valid(float_win) then
    if vim.api.nvim_get_current_win() ~= float_win then
      vim.api.nvim_set_current_win(float_win)
    else
      disable_floating_diary()
    end
    return
  end

  enable_floating_diary()
end

vim.keymap.set("n", "<C-d>", toggle_split_float, { desc = "Toggle Obsidian Float" })
vim.api.nvim_create_user_command("FloatingDiary", toggle_split_float, { desc = "Toggle Obsidian Float" })
