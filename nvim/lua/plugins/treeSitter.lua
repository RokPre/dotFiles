return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "master",
    config = function()
      vim.filetype.add({
        extension = {
          launch = "xml",
        },
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
          "markdown_inline",
          "xml",
        },
        auto_install = true,
        highlight = {
          enable = true,
        },
      })
    end,
  },
}
