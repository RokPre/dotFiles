return {
	"supermaven-inc/supermaven-nvim",
	event = "BufRead",
	config = function()
		require("supermaven-nvim").setup({
			keymaps = {
				accept_suggestion = "<C-q>",
				accept_word = "<C-a>",
			},
		})
	end,
}
