local ns_id = vim.api.nvim_create_namespace("todo_highlight")

-- Define the highlight style
vim.api.nvim_set_hl(0, "TodoHL", { bg = "#ff8800", fg = "#ffffff", bold = true })

-- Highlight all "TODO" words in the current buffer
local function highlight_todos()
  vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  for lnum, line in ipairs(lines) do
    local start = 1
    while true do
      local from, to = string.find(line, "%f[%w]TODO%f[%W]", start)
      if not from then break end
      vim.api.nvim_buf_add_highlight(0, ns_id, "TodoHL", lnum - 1, from - 1, to)
      start = to + 1
    end
  end
end

-- Run it
highlight_todos()
