return {
	"nvim-treesitter/nvim-treesitter",
	"nvim-treesitter/playground",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "css", "html", "javascript", "python", "latex", "scss", "tsx", "markdown" },
			highlight = {
				enable = true,
			},
		})
	end,
}
