return {
	"jiaoshijie/undotree",
	dependencies = "nvim-lua/plenary.nvim",
	config = true,
	keys = { -- load the plugin only when using it's keybinding:
		{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
	},
	config = function()
		require("undotree").setup({
			float_diff = false,
			layout = "left_left_bottom",
			position = "left",
		})
	end,
}
