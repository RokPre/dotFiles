return {
	{
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async" },
		config = function()
			-- vim.o.foldcolumn = "1" -- sets foldcolumn to 1
			vim.o.foldlevel = 99 -- high foldlevel for ufo provider
			vim.o.foldlevelstart = 99 -- ensures folds are open by default
			vim.o.foldenable = true -- enables folding

			-- Remap keys for opening and closing folds provided by nvim-ufo
			vim.keymap.set("n", "zR", require("ufo").openAllFolds)
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

			-- Folding folding folds
			local function fold()
				local col = vim.api.nvim_win_get_cursor(0)[2]
				local line = vim.fn.getline(".")
				local fnbc1 = #vim.fn.matchstr(line, "^\\s*")
				-- local fnbc2 = vim.fn.getline("."):find("%S")
				-- local fnbc3 = vim.fn.match(vim.fn.getline("."), "\\S") + 1
				if col <= fnbc1 then
					vim.cmd(":silent! foldclose")
				else
					vim.api.nvim_feedkeys("h", "n", false)
				end
			end
			vim.keymap.set("n", "h", fold, {})

			require("ufo").setup() -- initialize ufo
		end,
	},
}
