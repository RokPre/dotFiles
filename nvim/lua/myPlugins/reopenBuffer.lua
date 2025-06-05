-- ✅ feature complete
local keymap = vim.keymap.set
local closed_buffers = {}

-- autocmd to store closed buffer
vim.api.nvim_create_autocmd("BufDelete", {
  callback = function(args)
    local bufnr = args.buf
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    if bufname ~= "" then
      table.insert(closed_buffers, 1, bufname) -- Store at the start
    end
  end,
})

local function reopen_last_buffer()
  if #closed_buffers == 0 then
    vim.notify("No recently closed buffers!", vim.log.levels.WARN)
    return
  end
  local last_buffer = table.remove(closed_buffers, 1) -- Remove and return last closed
  vim.cmd("edit " .. vim.fn.fnameescape(last_buffer))
end

-- Keymap to reopen last closed buffer
vim.api.nvim_create_user_command("ReopenLastBuffer", reopen_last_buffer, {})
keymap("n", "<C-S-t>", reopen_last_buffer, { noremap = true, silent = true })
