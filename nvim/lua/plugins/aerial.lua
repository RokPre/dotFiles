return {
	"stevearc/aerial.nvim",
	-- Optional dependencies
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("aerial").setup({
			attach_mode = "global",
			backends = { "lsp", "treesitter", "markdown", "man" },
			show_guides = true,
			close_automatic_events = { "unsupported", "unfocus", "switch_buffer" },
			close_on_select = true,
			autojump = true,
			highlight_on_jump = 500,
			layout = {
				resize_to_content = true,
				default_direction = "prefer_right",
				win_opts = {
					winhl = "Normal:NormalFloat,FloatBorder:NormalFloat,SignColumn:SignColumnSB",
					statuscolumn = " ",
				},
			},
			icons = {
				Class = "󰠱",
				Enum = "󰒻",
				Function = "󰊕",
				Object = "󰅩",
				Collapsed = "",
			},
			get_highlight = function()
				vim.api.nvim_set_hl(0, "AerialLine", { fg = "None", bg = "#283457", bold = true })
			end,
			link_tree_to_folds = true,
		})
		vim.keymap.set("n", "<leader>a", "<Nop>", { desc = "Aerial" })
		vim.keymap.set("n", "<leader>aa", "<cmd>AerialOpen<cr>", { desc = "Open aerial" })
		vim.keymap.set("n", "<leader>al", "<cmd>AerialClose<cr><cmd>AerialOpen left<cr>", { desc = "Open left" })
		vim.keymap.set("n", "<leader>ar", "<cmd>AerialClose<cr><cmd>AerialOpen right<cr>", { desc = "Open right" })
		vim.keymap.set("n", "<leader>ac", "<cmd>AerialClose<cr>", { desc = "Close aerial" })
		vim.keymap.set("n", "<leader>an", "<cmd>AerialNavToggle<cr>", { desc = "Toggle aerial" })

		vim.api.nvim_create_autocmd("VimLeavePre", {
			callback = function()
				vim.cmd("AerialClose")
			end,
		})
	end,
}
