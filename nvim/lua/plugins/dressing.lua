return {
  "stevearc/dressing.nvim",
  config = function()
    require("dressing").setup({
      input = {},
      select = {
        enabled = true,
        backend = { "telescope" },
        telescope = {
          width = 0.8,
          height = 0.8
        }
      }
    })
  end
}
