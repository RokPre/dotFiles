local home = os.getenv("HOME")
local vaultName = "knowledgeVault"
local vaultPath = home .. "/sync/" .. vaultName
local uv = vim.loop

vim.keymap.set("n", "<Leader>o", "<Nop>", { noremap = true, silent = true, desc = "Obsidian" })
vim.keymap.set("n", "<Leader>on", "<Cmd>ObsidianNew<CR>", { noremap = true, silent = true, desc = "New Note" })
vim.keymap.set("n", "<Leader>oo", "<Cmd>ObsidianSearch<CR>", { noremap = true, silent = true, desc = "Open Notes" })
vim.keymap.set("n", "<Leader>oO", "<Cmd>ObsidianOpen<CR>",
  { noremap = true, silent = true, desc = "Open in Obsidian" })
vim.keymap.set("n", "<Leader>or", "<Cmd>ObsidianRename<Cr>", { noremap = true, silent = true, desc = "Rename Note" })
vim.keymap.set("n", "<Leader>ob", "<Cmd>ObsidianBacklinks<Cr>",
  { noremap = true, silent = true, desc = "Show backlinks" })
vim.keymap.set("n", "<Leader>ot", "<Cmd>ObsidianTemplate<Cr>",
  { noremap = true, silent = true, desc = "Template" })

local function OpenExcalidraw()
  -- Check is obisidian is open
  local result = vim.fn.systemlist("pgrep -x obsidian")
  local defer = 0
  if #result == 0 then
    local uri = string.format("obsidian://open?vault=%s", vaultName)
    vim.fn.jobstart({ "xdg-open", uri }, { detach = true })
    defer = 2000
  end

  local buffer_name = vim.api.nvim_buf_get_name(0)
  local filename = vim.fn.fnamemodify(buffer_name, ":t:r")
  local sketch_name = filename .. "_" .. os.date("%Y-%m-%d-%H-%M-%S") .. ".excalidraw.md"
  local sketch_image = sketch_name:gsub(".md", ".svg")
  local sketch_path = "Attachment%20folder%2FExcalidraw%2F" .. sketch_name

  local content = [[---

excalidraw-plugin: parsed
tags: [excalidraw]

---
%23%23 Drawing
```compressed-json
N4IgLgngDgpiBcIYA8DGBDANgSwCYCd0B3EAGhADcZ8BnbAewDsEAmcm+gV31TkQAswYKDXgB6MQHNsYfpwBGAOlT0AtmIBeNCtlQbs6RmPry6uA4wC0KDDgLFLUTJ2lH8MTDHQ0YNMWHRJMRZFAEYAVjCyJE9VGEYwGgQAbQBdcnQoKABlALA+UFkYOIQQXHR8AGtoyXw8bOwNPkZOTExyHRgiACF0VErarkZcAGF6THp8UoBiADN5hZAAXyWgA
```
%25%25
]]

  local uri_new = string.format(
    "obsidian://new?vault=%s&file=%s&content=%s",
    vaultName,
    sketch_path,
    content
  )

  local uri_open = string.format(
    "obsidian://open?vault=%s&file=%s",
    vaultName,
    sketch_path
  )

  -- Open Obsidian
  vim.defer_fn(function()
    vim.fn.jobstart({ "xdg-open", uri_new }, { detach = true })
    vim.defer_fn(function()
      vim.fn.jobstart({ "xdg-open", uri_open }, { detach = true })
    end, 2000)
  end, defer)
  -- Insert embed link into current note
  local link = string.format("![image](%s)", sketch_image)
  vim.api.nvim_put({ link }, "l", true, true)
end

vim.keymap.set("n", "<Leader>oe", OpenExcalidraw, {})

return {
  "RokPre/obsidian.nvim",
  cond = function()
    local stat = uv.fs_stat(vaultPath)
    return stat and stat.type == "directory"
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    preferred_link_content = "filename",
    workspaces = {
      {
        -- name = "vault",
        name = "vault",
        path = vaultPath,
      },
    },
    disable_frontmatter = true,
    templates = {
      folder = "template",
      date_format = "%Y - %j",
      time_format = "%H:%M",
      substitutions = {
        today = function()
          return os.date("%Y %B %d - %A")
        end,
        yesterday = function()
          return os.date("%Y - %j", os.time() - 86400)
        end,
        tomorrow = function()
          return os.date("%Y - %j", os.time() + 86400)
        end,
        day = function()
          return os.date("%A")
        end,
        id = function()
          return os.time(os.date("!*t")) -- not unix timestamp
        end,
      },
    },
    daily_notes = {
      folder = "Dnevnik",
      date_format = "%Y - %j",
      template = "Neovim-DailyNote-template.md",
    },
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },
    ui = {
      enable = false,
    },
    attachments = {
      folder = "Attachment folder",
      img_folder = "Attachment folder"
    },
  },
}
