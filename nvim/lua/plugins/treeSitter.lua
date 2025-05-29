vim.keymap.set("n", "n", "<Nop>", {desc = "Next"})
vim.keymap.set("n", "N", "<Nop>", {desc = "Prev"})
vim.keymap.set("n", "e", "<Nop>", {desc = "End of"})
vim.keymap.set("n", "b", "<Nop>", {desc = "Begging of prev"})
vim.keymap.set("n", "w", "<Nop>")
vim.keymap.set("n", "W", "<Nop>")
vim.keymap.set("n", "e", "<Nop>")
vim.keymap.set("n", "E", "<Nop>")
vim.keymap.set("n", "b", "<Nop>")
vim.keymap.set("n", "B", "<Nop>")

-- Sentence navigation
vim.keymap.set("n", "ns", ")")
vim.keymap.set("n", "Ns", "(")
vim.keymap.set("n", "es", ")")
vim.keymap.set("n", "bs", "(")

vim.keymap.set("n", "nw", "w")
vim.keymap.set("n", "Nw", "b")
vim.keymap.set("n", "ew", "e")
vim.keymap.set("n", "bw", "bbe")

vim.keymap.set("n", "nW", "W")
vim.keymap.set("n", "NW", "B")
vim.keymap.set("n", "eW", "E")
vim.keymap.set("n", "bW", "BBE")

return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"nvim-treesitter/playground",
		},
		config = function()
      vim.filetype.add({
        extension = {
          launch = "xml"
        }
      })
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"css",
					"html",
					"javascript",
					"python",
					"latex",
					"scss",
					"tsx",
					"markdown",
          "xml"
				},
        fold = {enable = true},
				sync_install = true,
				auto_install = true,
				ignore_install = { "" },
				modules = {},
				highlight = {
					enable = true,
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["ac"] = "@class.outer",
							["al"] = "@loop.outer",
							["ap"] = "@parameter.outer",
							["ai"] = "@conditional.outer",
							["ar"] = "@return.outer",
							["aa"] = "@assignment.outer",
							["am"] = "@comment.outer",
							["ab"] = "@block.outer",
							["if"] = "@function.inner",
							["ic"] = "@class.inner",
							["il"] = "@loop.inner",
							["ip"] = "@parameter.inner",
							["ii"] = "@conditional.inner",
							["ir"] = "@return.inner",
							["ia"] = "@assignment.inner",
							["im"] = "@comment.inner",
							["ib"] = "@block.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["nf"] = "@function.outer",
							["nc"] = "@class.outer",
							["nl"] = "@loop.outer",
							["np"] = "@parameter.outer",
							["ni"] = "@conditional.outer",
							["nr"] = "@return.outer",
							["na"] = "@assignment.outer",
							["nm"] = "@comment.outer",
							["nb"] = "@block.outer",
              ["nC"] = "@comment.outer",
						},
						goto_previous_start = {
							["Nf"] = "@function.outer",
							["Nc"] = "@class.outer",
							["Nl"] = "@loop.outer",
							["Np"] = "@parameter.outer",
							["Ni"] = "@conditional.outer",
							["Nr"] = "@return.outer",
							["Na"] = "@assignment.outer",
							["Nm"] = "@comment.outer",
							["Nb"] = "@block.outer",
              ["NC"] = "@comment.outer",
						},
						goto_next_end = {
							["ef"] = "@function.outer",
							["ec"] = "@class.outer",
							["el"] = "@loop.outer",
							["ep"] = "@parameter.outer",
							["ei"] = "@conditional.outer",
							["er"] = "@return.outer",
							["ea"] = "@assignment.outer",
							["em"] = "@comment.outer",
							["eb"] = "@block.outer",
              ["eC"] = "@comment.outer",
						},
						goto_previous_end = {
							["bf"] = "@function.outer",
							["bc"] = "@class.outer",
							["bl"] = "@loop.outer",
							["bp"] = "@parameter.outer",
							["bi"] = "@conditional.outer",
							["br"] = "@return.outer",
							["ba"] = "@assignment.outer",
							["bm"] = "@comment.outer",
							["bb"] = "@block.outer",
              ["bC"] = "@comment.outer",
						},
					},
				},
			})
		end,
	},
}
