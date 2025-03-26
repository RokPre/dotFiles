return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
				globalstatus = true,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				theme = "auto",
			},
			tabline = {},
			sections = {
				lualine_a = { "branch" },
				lualine_b = { "diff" },
				lualine_c = {},
				lualine_x = {
					"filename",
					function()
						return vim.fn.expand("%:p:h")
					end,
					"data",
				},
				lualine_y = {},
				lualine_z = {
					function()
						local time = os.date("*t")
						local hour = time.hour
						local minute = time.min

						local Hours = {
							"Midnight",
							"One",
							"Two",
							"Three",
							"Four",
							"Five",
							"Six",
							"Seven",
							"Eight",
							"Nine",
							"Ten",
							"Eleven",
							"Noon",
							"One",
							"Two",
							"Three",
							"Four",
							"Five",
							"Six",
							"Seven",
							"Eight",
							"Nine",
							"Ten",
							"Eleven",
						}

						local phrases = {
							[0] = string.format("%s o'clock", Hours[hour + 1]),
							[1] = string.format("Quarter past %s", string.lower(Hours[hour + 1])),
							[2] = string.format("Half past %s", string.lower(Hours[hour + 1])),
							[3] = string.format("Quarter to %s", string.lower(Hours[hour + 2])),
							[4] = string.format("%s o'clock", Hours[hour + 2]),
						}

						local minute_index = math.floor((minute + 7.5) / 15) -- Round to nearest quarter
						return phrases[minute_index] -- quarter past, half past, quarter to
					end,
					"data",
				},
			},
			extensions = { "quickfix", "fugitive", "nvim-tree" },
		})
	end,
}
