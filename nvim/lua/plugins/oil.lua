return {
	"stevearc/oil.nvim",
	opts = {},
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	config = function()
		vim.keymap.set("n", "<Leader>e", "<Cmd>Oil<CR>", { noremap = true, silent = true, desc = "File picker" })
		require("oil").setup({
			default_file_explorer = true,
			columns = {
				"icon",
				"size",
			},
			view_options = {
				show_hidden = false,
			},
			keymaps = {
				["<leader>h"] = "actions.show_help",
				["l"] = "actions.select",
				["<leader>v"] = {
					"actions.select",
					opts = { vertical = true },
					desc = "Open the entry in a vertical split",
				},
				["<leader>b"] = {
					"actions.select",
					opts = { horizontal = true },
					desc = "Open the entry in a horizontal split",
				},
				["<leader>t"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
				["<C-p>"] = {
					callback = function()
						local oil = require("oil")
						oil.open_preview({ vertical = true, split = "botright" }, function(err) end)
					end,
				},
				["q"] = "actions.close",
				["<leader>r"] = "actions.refresh",
				["h"] = "actions.parent",
				["<leader>c"] = "actions.open_cwd",
				["<leader>d"] = "actions.cd",
				["<Leader>cwd"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
				["<leader>s"] = "actions.change_sort",
				["<leader>x"] = "actions.open_external",
				["<leader>."] = "actions.toggle_hidden",
				["<leader>/"] = "actions.toggle_trash",
				["<leader>y"] = "actions.yank_entry",
				["<leader>S"] = {
					callback = function()
						local connections = {
							{ name = "turtlebot3", uri = "ubuntu@192.168.9.111" },
							-- add more connections here if you want
						}
						vim.ui.select(connections, {
							prompt = "Select connection",
							format_item = function(item)
								return item.name
							end,
						}, function(selected)
							if not selected then
								return
							end
							local cmd = "e oil-ssh://" .. selected.uri .. "/"
							vim.cmd(cmd)
						end)
					end,
					desc = "Connect over SSH with Oil",
				},
			},
			preview_win = {
				update_on_cursor_moved = true,
				preview_method = "fast_scratch",
				preview_split = "below",
			},
		})
	end,
}
