return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"nvim-treesitter/playground",
		},
		config = function()
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
				},
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
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
				},
			})
		end,
	},
}
