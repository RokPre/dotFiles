return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",
	keys = {
		{ "<C-S-h>", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
		{ "<C-S-l>", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
		{ "<A-e>", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
		{ "<A-q>", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
		{ "<C-h>", "<Cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
		{ "<C-l>", "<Cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
		{ "<C-e>", "<Cmd>BufferLinePick<cr>", desc = "Pick buffer" },
	},
	opts = {
		options = {
			always_show_bufferline = false,
			show_close_icon = false,
			show_buffer_close_icons = false,
			separator_style = "slope",
			truncate_names = false,
			offsets = {
				{
					filetype = "neo-tree",
					text = "Neo-tree",
					highlight = "Directory",
					text_align = "left",
					separator = false,
				},
				{
					filetype = "snacks_layout_box",
				},
			},
			indicator = {
				style = "none",
			},
		},
	},
	config = function(_, opts)
		require("bufferline").setup(opts)
		-- Fix bufferline when restoring a session
		vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
			callback = function()
				vim.schedule(function()
					pcall(require, "bufferline")
					local ok, a = pcall(require, "config.appearance")
					if ok then
						vim.api.nvim_set_hl(0, "BufferLineFill", { bg = a.bg_dark })
						vim.api.nvim_set_hl(0, "BufferLineBackground", { fg = a.fg_dark, bg = a.bg_dark })
						vim.api.nvim_set_hl(0, "BufferLineBufferSelected", { fg = a.orange, bg = a.bg })
						vim.api.nvim_set_hl(0, "BufferLineBufferVisible", { fg = a.orange_dull, bg = a.bg })

						vim.api.nvim_set_hl(0, "BufferLineSeparator", { fg = a.bg_dark, bg = a.bg_dark })
						vim.api.nvim_set_hl(0, "BufferLineSeparatorSelected", { fg = a.bg_dark, bg = a.bg })
						vim.api.nvim_set_hl(0, "BufferLineSeparatorVisible", { fg = a.bg_dark, bg = a.bg })

						vim.api.nvim_set_hl(0, "BufferLineDuplicate", { fg = a.fg, bg = a.bg })
						vim.api.nvim_set_hl(0, "BufferLineDuplicateSelected", { fg = a.orange, bg = a.bg })
						vim.api.nvim_set_hl(0, "BufferLineDuplicateVisible", { fg = a.fg, bg = a.bg })
					end
				end)
			end,
		})
	end,
}
