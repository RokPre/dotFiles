return {
	"norcalli/nvim-colorizer.lua",
	config = function()
		vim.opt.termguicolors = true
		require("colorizer").setup({
			"*", -- Enable for all file types
		})
	end,
}
