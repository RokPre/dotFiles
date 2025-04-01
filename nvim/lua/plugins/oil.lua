return {
	"stevearc/oil.nvim",
	opts = {},
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	config = function()
		require("oil").setup({
			default_file_explorer = true,
			view_options = {
				show_hidden = true,
			},
			keymaps = {
				["g?"] = "actions.show_help",
				["l"] = "actions.select",
				["<C-s>"] = {
					"actions.select",
					opts = { vertical = true },
					desc = "Open the entry in a vertical split",
				},
				["<C-h>"] = {
					"actions.select",
					opts = { horizontal = true },
					desc = "Open the entry in a horizontal split",
				},
				["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
				["<C-p>"] = {
					callback = function()
						local oil = require("oil")
						oil.open_preview({ vertical = true, split = "botright" }, function(err) end)
					end,
				},
				["q"] = "actions.close",
				["<C-l>"] = "actions.refresh",
				["h"] = "actions.parent",
				["_"] = "actions.open_cwd",
				["`"] = "actions.cd",
				["<Leader>cwd"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
				["gs"] = "actions.change_sort",
				["gx"] = "actions.open_external",
				["g."] = "actions.toggle_hidden",
				["g\\"] = "actions.toggle_trash",
			},
			preview_win = {
				update_on_cursor_moved = true, -- Automatically update the preview
				preview_method = "fast_scratch", -- Ensure a fast preview experience
				preview_split = "below",
			},
		})
	end,
}
