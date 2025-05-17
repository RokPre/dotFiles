return {
  "stevearc/oil.nvim",
  opts = {},
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  config = function()
    vim.keymap.set("n", "<Leader>o", "<Nop>", { noremap = true, silent = true, desc = "Oil" })
    vim.keymap.set("n", "<Leader>oo", "<Cmd>Oil<CR>", { noremap = true, silent = true, desc = "File picker" })
    require("oil").setup({
      default_file_explorer = true,
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ["<Leader>oh"] = "actions.show_help",
        ["l"] = "actions.select",
        ["<Leader>ov"] = {
          "actions.select",
          opts = { vertical = true },
          desc = "Open the entry in a vertical split",
        },
        ["<Leader>ob"] = {
          "actions.select",
          opts = { horizontal = true },
          desc = "Open the entry in a horizontal split",
        },
        ["<Leader>ot"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
        ["<C-p>"] = {
          callback = function()
            local oil = require("oil")
            oil.open_preview({ vertical = true, split = "botright" }, function(err) end)
          end,
        },
        ["q"] = "actions.close",
        ["<Leader>or"] = "actions.refresh",
        ["h"] = "actions.parent",
        ["<Leader>oc"] = "actions.open_cwd",
        ["<Leader>od"] = "actions.cd",
        ["<Leader>cwd"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
        ["<Leader>os"] = "actions.change_sort",
        ["<Leader>ox"] = "actions.open_external",
        ["<Leader>o."] = "actions.toggle_hidden",
        ["<Leader>o/"] = "actions.toggle_trash",
        ["<Leader>oy"] = "actions.yank_entry",
      },
      preview_win = {
        update_on_cursor_moved = true,   -- Automatically update the preview
        preview_method = "fast_scratch", -- Ensure a fast preview experience
        preview_split = "below",
      },
    })
  end,
}
