local M = {}
local loop = vim.loop
local api = vim.api
function M.convertFile()
  local shortname = vim.fn.expand('%:t:r')
  local fullname = api.nvim_buf_get_name(0)
  handle = vim.loop.spawn('true', { }, function()
    vim.print('DOCUMENT CONVERSION COMPLETE')
    handle:close()
  end
  )
end

vim.api.nvim_create_user_command('TestConvertFile', M.convertFile, {})

return M
