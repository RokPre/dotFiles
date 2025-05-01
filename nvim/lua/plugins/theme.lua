return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
	{
		"neanias/everforest-nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			require("everforest").setup({
				-- Your config here
			})
		end,
	},
  {"navarasu/onedark.nvim"}
}
