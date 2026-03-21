return {
	"hat0uma/csvview.nvim",
	ft = "csv",
	opts = {
		parser = { comments = { "#", "//" } },
		keymaps = {
			textobject_field_inner = { "if", mode = { "o", "x" } },
			textobject_field_outer = { "af", mode = { "o", "x" } },
			jump_next_field_end = { "l", mode = { "n", "v" } },
			jump_prev_field_end = { "h", mode = { "n", "v" } },
			jump_next_row = { "j", mode = { "n", "v" } },
			jump_prev_row = { "k", mode = { "n", "v" } },
		},
	},
	config = function(_, opts)
		require("csvview").setup(opts)
		vim.cmd("CsvViewEnable")
	end,
	cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
}
