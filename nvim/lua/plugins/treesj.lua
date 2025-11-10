return {
	"Wansmer/treesj",
	dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
	config = function()
		local treesj = require("treesj")
		treesj.setup({
      max_join_length = 9999
    })
		vim.keymap.set("n", "<leader>j", treesj.toggle, { desc = "Toggle list" })
	end,
}
