return {
	"supermaven-inc/supermaven-nvim",
	lazy = false,
	event = "VeryLazy",
	config = function()
		require("supermaven-nvim").setup({
			keymaps = {
				accept_suggestion = "<C-q>",
				accept_word = "<C-a>",
			},
			filetypes ={ python = true, lua = true, markdown = true}
		})
	end,
}
