return {
	"sindrets/winshift.nvim",
	config = function()
		require("winshift").setup({
			keymaps = {
				["<A-S-h>"] = "left",
				["<A-S-l>"] = "right",
				["<A-S-j>"] = "down",
				["<A-S-k>"] = "up",
			},
		})
	end,
}
