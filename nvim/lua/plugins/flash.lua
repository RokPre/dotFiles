return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    search = {
      mode = "fuzzy",
    },
    modes = {
      search = {
        enabled = true, -- still integrate with `/` and `?`
      },
      char = {
        enabled = false, -- disable f/F/t/T/;/,
      },
    },
  },
}
