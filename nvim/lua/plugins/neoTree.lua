return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        window = {
          mappings = {
            ["l"] = "open",
            ["h"] = "close_node",
            ["v"] = "open_vsplit",
            ["b"] = "open_split",
          }
        }
      })
      vim.api.nvim_set_keymap("n", "<Leader>e", ":Neotree toggle<CR>", { noremap = true, silent = true })
    end,
}

