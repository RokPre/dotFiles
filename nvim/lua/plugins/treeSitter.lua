-- vim.keymap.set("n", "n", "<Nop>", {desc = "Next"})
-- vim.keymap.set("n", "N", "<Nop>", {desc = "Prev"})
-- vim.keymap.set("n", "e", "<Nop>", {desc = "End of"})
-- vim.keymap.set("n", "b", "<Nop>", {desc = "Begging of prev"})
-- vim.keymap.set("n", "w", "<Nop>")
-- vim.keymap.set("n", "W", "<Nop>")
-- vim.keymap.set("n", "e", "<Nop>")
-- vim.keymap.set("n", "E", "<Nop>")
-- vim.keymap.set("n", "b", "<Nop>")
-- vim.keymap.set("n", "B", "<Nop>")
--
-- -- Sentence navigation
-- vim.keymap.set("n", "ns", ")")
-- vim.keymap.set("n", "Ns", "(")
-- vim.keymap.set("n", "es", ")")
-- vim.keymap.set("n", "bs", "(")
--
-- vim.keymap.set("n", "nw", "w")
-- vim.keymap.set("n", "Nw", "b")
-- vim.keymap.set("n", "ew", "e")
-- vim.keymap.set("n", "bw", "bbe")
--
-- vim.keymap.set("n", "nW", "W")
-- vim.keymap.set("n", "NW", "B")
-- vim.keymap.set("n", "eW", "E")
-- vim.keymap.set("n", "bW", "BBE")

-- These keymaps are in ufo.lua
-- ~/sync/dotFiles/nvim/lua/plugins/ufo.lua
-- local ufo = require("ufo")
-- vim.keymap.set("n", "nz", ufo.goNextClosedFold, {desc = "Next closed fold (UFO)"})
-- vim.keymap.set("n", "Nz", ufo.goPreviousClosedFold, {desc = "Next closed fold (UFO)"})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/playground",
    },
    config = function()
      vim.filetype.add({
        extension = {
          launch = "xml"
        }
      })
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "css",
          "html",
          "javascript",
          "python",
          "latex",
          "scss",
          "tsx",
          "markdown",
          "xml"
        },
        fold = { enable = true },
        sync_install = true,
        auto_install = true,
        ignore_install = { "" },
        modules = {},
        highlight = {
          enable = true,
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["ac"] = "@class.outer",
              ["al"] = "@loop.outer",
              ["ap"] = "@parameter.outer",
              ["ai"] = "@conditional.outer",
              ["ar"] = "@return.outer",
              ["aa"] = "@assignment.outer",
              ["am"] = "@comment.outer",
              ["ab"] = "@block.outer",
              ["if"] = "@function.inner",
              ["ic"] = "@class.inner",
              ["il"] = "@loop.inner",
              ["ip"] = "@parameter.inner",
              ["ii"] = "@conditional.inner",
              ["ir"] = "@return.inner",
              ["ia"] = "@assignment.inner",
              ["im"] = "@comment.inner",
              ["ib"] = "@block.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
              ["]l"] = "@loop.outer",
              ["]p"] = "@parameter.outer",
              ["]i"] = "@conditional.outer",
              ["]r"] = "@return.outer",
              ["]a"] = "@assignment.outer",
              ["]b"] = "@block.outer",
              ["]C"] = "@comment.outer",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
              ["[l"] = "@loop.outer",
              ["[p"] = "@parameter.outer",
              ["[i"] = "@conditional.outer",
              ["[r"] = "@return.outer",
              ["[a"] = "@assignment.outer",
              ["[b"] = "@block.outer",
              ["[C"] = "@comment.outer",
            },
            goto_next_end = {
              ["}f"] = "@function.outer",
              ["}c"] = "@class.outer",
              ["}l"] = "@loop.outer",
              ["}p"] = "@parameter.outer",
              ["}i"] = "@conditional.outer",
              ["}r"] = "@return.outer",
              ["}a"] = "@assignment.outer",
              ["}b"] = "@block.outer",
              ["}C"] = "@comment.outer",
            },
            goto_previous_end = {
              ["{f"] = "@function.outer",
              ["{c"] = "@class.outer",
              ["{l"] = "@loop.outer",
              ["{p"] = "@parameter.outer",
              ["{i"] = "@conditional.outer",
              ["{r"] = "@return.outer",
              ["{a"] = "@assignment.outer",
              ["{b"] = "@block.outer",
              ["{C"] = "@comment.outer",
            },
          },
        },
      })
    end,
  },
}
