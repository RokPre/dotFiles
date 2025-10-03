return {
  "stevearc/oil.nvim",
  opts = {},
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  config = function()
    vim.keymap.set("n", "<Leader>e", "<Nop>", { noremap = true, silent = true, desc = "Oil" })
    vim.keymap.set("n", "<Leader>ee", "<Cmd>Oil<CR>", { noremap = true, silent = true, desc = "File picker" })
    require("oil").setup({
      default_file_explorer = true,
      columns = {
        "icon",
        "size",
      },
      view_options = {
        show_hidden = false,
      },
      keymaps = {
        ["<Leader>eh"] = "actions.show_help",
        ["l"] = "actions.select",
        ["<Leader>ev"] = {
          "actions.select",
          opts = { vertical = true },
          desc = "Open the entry in a vertical split",
        },
        ["<Leader>eb"] = {
          "actions.select",
          opts = { horizontal = true },
          desc = "Open the entry in a horizontal split",
        },
        ["<Leader>et"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
        ["<C-p>"] = {
          callback = function()
            local oil = require("oil")
            oil.open_preview({ vertical = true, split = "botright" }, function(err) end)
          end,
        },
        ["q"] = "actions.close",
        ["<Leader>er"] = "actions.refresh",
        ["h"] = "actions.parent",
        ["<Leader>ec"] = "actions.open_cwd",
        ["<Leader>ed"] = "actions.cd",
        ["<Leader>cwd"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
        ["<Leader>es"] = "actions.change_sort",
        ["<Leader>ex"] = "actions.open_external",
        ["<Leader>e."] = "actions.toggle_hidden",
        ["<Leader>e/"] = "actions.toggle_trash",
        ["<Leader>ey"] = "actions.yank_entry",
        ["<Leader>eS"] = {
          callback = function()
            local connections = {
              { name = "turtlebot3", uri = "ubuntu@192.168.9.111" },
              -- add more connections here if you want
            }
            vim.ui.select(connections, {
              prompt = "Select connection",
              format_item = function(item) return item.name end,
            }, function(selected)
              if not selected then return end
              local cmd = "e oil-ssh://" .. selected.uri .. "/"
              print(cmd)
              vim.cmd(cmd)
            end)
          end,
          desc = "Connect over SSH with Oil",
        },
      },
      preview_win = {
        update_on_cursor_moved = true,
        preview_method = "fast_scratch",
        preview_split = "below",
      },
    })
  end,
}
