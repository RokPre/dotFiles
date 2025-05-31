vim.g.DiaryMode = false
local session_file = vim.fn.stdpath("cache") .. "/diary_sesion.vim"

local function enableDiaryMode()
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
      vim.api.nvim_open_win(empty, false, { split = "left", width = margin, style = "minimal" } )
      vim.api.nvim_open_win(empty, true, { split = "right" })
      vim.api.nvim_open_win(empty, false, { split = "right", width = margin, style = "minimal"  })
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
  local ok = pcall(require, "obsidian")
  if not ok then
    vim.notify("Obsidian.nvim is not loaded", vim.log.levels.ERROR)
    return
  end
  if vim.g.DiaryMode then
    dissableDiaryMode()
  else
    enableDiaryMode()
  end
  vim.g.DiaryMode = not vim.g.DiaryMode
end

vim.keymap.set("n", "<C-d>", toggleDiaryMode, { desc = "Enable diary mode"})
vim.api.nvim_create_user_command("DiaryModeToggle", toggleDiaryMode, {})
