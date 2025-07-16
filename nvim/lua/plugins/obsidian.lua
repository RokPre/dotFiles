local home = os.getenv("HOME")
local vaultPath = home .. "/sync/vault"
local uv = vim.loop

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
    -- checkboxes = {
    --   [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
    --   ["x"] = { char = "", hl_group = "ObsidianDone" },
    -- },
    attachments = {
      folder = "Attachment folder",
      img_folder = "Attachment folder"
    },
  },
}
