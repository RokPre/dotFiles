vim.g.DiaryMode = false
local session_file = vim.fn.stdpath("cache") .. "/diary_sesion.vim"

local function set_backgournd_color_of_margin(factor, win)
  local bg_color = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
  local bg_color_hex = string.format("#%06x", bg_color)
  bg_color_hex = bg_color_hex:gsub("#", "")

  local r = tonumber(bg_color_hex:sub(1, 2), 16)
  local g = tonumber(bg_color_hex:sub(3, 4), 16)
  local b = tonumber(bg_color_hex:sub(5, 6), 16)

  r = math.max(0, math.min(255, math.floor(r * factor)))
  g = math.max(0, math.min(255, math.floor(g * factor)))
  b = math.max(0, math.min(255, math.floor(b * factor)))

  local dimmed = string.format("#%02x%02x%02x", r, g, b)

  -- Define custom highlight
  vim.api.nvim_set_hl(0, "MyCustomBackground", { bg = dimmed })

  -- Apply to window
  vim.api.nvim_win_set_option(win, "winhighlight", "Normal:MyCustomBackground")
end

local function enableDiaryMode()
  vim.cmd("%argdel") -- Clear all args
  -- Delete all buffers
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)
    if name ~= "" and name:match("Dnevnik/2025") then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
  vim.cmd("mksession! " .. session_file)

  -- Delete all buffers
  local bufs = vim.api.nvim_list_bufs()
  for _, buf in ipairs(bufs) do
    vim.api.nvim_buf_delete(buf, { force = true })
  end

  -- Create a blank buffer to split later
  local empty = vim.api.nvim_create_buf(false, true)

  -- Set up an autocmd to split when the Obsidian buffer is added
  local group = vim.api.nvim_create_augroup("DiaryMode", { clear = true })
  vim.api.nvim_create_autocmd("BufAdd", {
    group = group,
    callback = function()
      local margin = math.floor((vim.o.columns - 160) / 2)
      -- Window open has to be in this order.
      local left_win = vim.api.nvim_open_win(empty, false, { split = "left", width = margin, style = "minimal"} )
      vim.api.nvim_open_win(empty, true, { split = "right" })
      local right_win = vim.api.nvim_open_win(empty, false, { split = "right", width = margin, style = "minimal"})
      vim.cmd("ObsidianToday") -- This then triggers the autocmd for setting the filetype
      vim.api.nvim_del_augroup_by_name("DiaryMode") -- prevent repeat

      local fgroup = vim.api.nvim_create_augroup("DiaryFixFileType", { clear = true })
      vim.api.nvim_create_autocmd("BufAdd", {
        group = fgroup,
        callback = function()
          local wins = vim.api.nvim_list_wins()
          for _, win in ipairs(wins) do
            -- Check if actually markdown file
            local bufName = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
            if bufName:match("%.md$") then
              vim.api.nvim_win_call(win, function()
                set_backgournd_color_of_margin(0.9, left_win)
                set_backgournd_color_of_margin(0.9, right_win)
                vim.cmd("setfiletype markdown")
              end)
            end
          end
          vim.api.nvim_del_augroup_by_name("DiaryFixFileType") -- prevent repeat
        end,
      })
    end,
  })

  -- Trigger the first ObsidianToday command (for yesterday)
  vim.cmd("ObsidianToday -1") -- This then triggers the autocmd for obsidian today
end

local function dissableDiaryMode()
  local bufs = vim.api.nvim_list_bufs()
  for _, buf in ipairs(bufs) do
    vim.api.nvim_buf_delete(buf, { force = true })
  end
  vim.cmd("source " .. session_file)
end

local function toggleDiaryMode()
  vim.g.DiaryMode = not vim.g.DiaryMode

  local ok = pcall(require, "obsidian")
  if not ok then
    local lazy_ok, lazy = pcall(require, "lazy")
    if not lazy_ok then
      vim.notify("Diary mode requires lazy.nvim and obsidian.nvim", vim.log.levels.ERROR)
      return
    end

    -- Try again
    ok = pcall(require, "obsidian")
    if not ok then
      vim.notify("Diary mode requires obsidian.nvim", vim.log.levels.ERROR)
      return
    end
  end

  if vim.g.DiaryMode then
    enableDiaryMode()
  else
    dissableDiaryMode()
  end
end

vim.keymap.set("n", "<C-d>", toggleDiaryMode, { desc = "Enable diary mode"})
vim.api.nvim_create_user_command("DiaryModeToggle", toggleDiaryMode, {})
