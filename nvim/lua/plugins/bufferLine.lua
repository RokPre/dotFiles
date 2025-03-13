return {
	"akinsho/bufferline.nvim",
	event = "VeryLazy",
	keys = {
		-- { "", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
		-- { "", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
		-- { "", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
		-- { "", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
		{ "<A-e>", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
		{ "<A-q>", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
		{ "<C-h>", "<Cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
		{ "<C-l>", "<Cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
		{ "<C-e>", "<Cmd>BufferLinePick<cr>", desc = "Pick buffer" },
	},
	opts = {
		options = {
			always_show_bufferline = false,
			offsets = {
				{
					filetype = "neo-tree",
					text = "Neo-tree",
					highlight = "Directory",
					text_align = "left",
				},
				{
					filetype = "snacks_layout_box",
				},
			},
		},
	},
	config = function(_, opts)
		require("bufferline").setup(opts)
		-- Fix bufferline when restoring a session
		vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
			callback = function()
				vim.schedule(function()
					pcall(nvim_bufferline)
				end)
			end,
		})
	end,
}
