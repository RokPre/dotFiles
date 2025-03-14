return {
	"karb94/neoscroll.nvim",
	config = function()
		local neoscroll = require("neoscroll")
		neoscroll.setup({
			easing_function = "quadratic",
		})

		local keymap = {
			["<M-d>"] = function()
				neoscroll.scroll(-5, { move_cursor = false, duration = 100 })
			end,
			["<M-f>"] = function()
				neoscroll.scroll(5, { move_cursor = false, duration = 100 })
			end,
			-- This is a bit stupid as you have `gg` and `G`
			["<M-S-d>"] = function()
				neoscroll.scroll(-5000, { move_cursor = false, duration = 100 })
			end,
			["<M-S-f>"] = function()
				neoscroll.scroll(5000, { move_cursor = false, duration = 100 })
			end,
		}

		for key, func in pairs(keymap) do
			vim.keymap.set("n", key, func, { silent = true, noremap = true })
		end
	end,
}
