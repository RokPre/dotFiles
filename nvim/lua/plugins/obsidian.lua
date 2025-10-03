local home = os.getenv("HOME")
local vaultPath = home .. "/sync/vault"
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
  -- Get current buffer name (full path)
  local buffer_name = vim.api.nvim_buf_get_name(0)

  -- Extract just the filename without path and extension
  local filename = vim.fn.fnamemodify(buffer_name, ":t:r")

  -- Append timestamp to make it unique
  local sketch_name = filename .. "-" .. os.date("%Y-%m-%d-%H-%M-%S") .. ".excalidraw.md"

  -- Build Obsidian URI (note the & before commandname!)
  -- local uri = string.format(
  --   "obsidian://advanced-uri?vault=%s&filename=%s&commandname=Excalidraw%%3A%%20New%%20drawing",
  --   vaultPath,
  --   sketch_name
  -- )


  local uri = string.format(
    "obsidian://advanced-uri?vault=%s",
    vaultPath
  )

  -- Debug prints
  vim.print("URI: " .. uri)
  vim.print("Sketch: " .. vaultPath)

  -- Open Obsidian
  uri = "obsidian://open?vault=vault&file=Dnevnik%2F2025%20-%20275"
  vim.fn.jobstart({ "xdg-open", uri }, { detach = true })

  -- Insert embed link into current note
  local link = string.format("![[%s]]", sketch_name)
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
