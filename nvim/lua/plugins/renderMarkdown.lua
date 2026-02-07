return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
	opts = {
		heading = {
			icons = {},
			width = "block",
			signs = {},
		},
		code = {
			language_border = " ",
			language_left = "",
			language_right = "",
			width = "block",
		},
	},
	config = function(_, opts)
		require("render-markdown").setup(opts)
		local ok, a = pcall(require, "config.appearance")
		if ok then
			vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = a.bg_lighter })
			vim.api.nvim_set_hl(0, "RenderMarkdownCodeBorder", { bg = a.bg_lighter })
		end
	end,
}
