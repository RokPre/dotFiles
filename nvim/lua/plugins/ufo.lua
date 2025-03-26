return {
	{
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async" },
		config = function()
			vim.o.foldcolumn = "1" -- sets foldcolumn to 1
			vim.o.foldlevel = 99 -- high foldlevel for ufo provider
			vim.o.foldlevelstart = 99 -- ensures folds are open by default
			vim.o.foldenable = true -- enables folding

			-- Remap keys for opening and closing folds provided by nvim-ufo
			vim.keymap.set("n", "zR", require("ufo").openAllFolds)
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

			require("ufo").setup() -- initialize ufo
		end,
	},
}
