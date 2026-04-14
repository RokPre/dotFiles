return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true,
					selection_modes = {
						["@function.outer"] = "V",
						["@function.inner"] = "v",
						["@class.outer"] = "V",
						["@class.inner"] = "v",
						["@parameter.outer"] = "v",
						["@parameter.inner"] = "v",
						["@call.outer"] = "v",
						["@call.inner"] = "v",
						["@conditional.outer"] = "V",
						["@conditional.inner"] = "v",
						["@loop.outer"] = "V",
						["@loop.inner"] = "V",
						["@comment.outer"] = "V",
						["@comment.inner"] = "V",
						["@return.inner"] = "v",
						["@return.outer"] = "V",
						["@assignment.inner"] = "v",
						["@assignment.outer"] = "V",
					},
				},
			})

			local select = require("nvim-treesitter-textobjects.select")

			vim.keymap.set({ "x", "o" }, "af", function()
				select.select_textobject("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "if", function()
				select.select_textobject("@function.inner", "textobjects")
			end)

			vim.keymap.set({ "x", "o" }, "ac", function()
				select.select_textobject("@class.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ic", function()
				select.select_textobject("@class.inner", "textobjects")
			end)

			vim.keymap.set({ "x", "o" }, "aa", function()
				select.select_textobject("@parameter.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ia", function()
				select.select_textobject("@parameter.inner", "textobjects")
			end)

			vim.keymap.set({ "x", "o" }, "aF", function()
				select.select_textobject("@call.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "iF", function()
				select.select_textobject("@call.inner", "textobjects")
			end)

			vim.keymap.set({ "x", "o" }, "ii", function()
				select.select_textobject("@conditional.inner", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ai", function()
				select.select_textobject("@conditional.outer", "textobjects")
			end)

			vim.keymap.set({ "x", "o" }, "il", function()
				select.select_textobject("@loop.inner", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "al", function()
				select.select_textobject("@loop.outer", "textobjects")
			end)

			vim.keymap.set({ "x", "o" }, "iC", function()
				select.select_textobject("@comment.inner", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "aC", function()
				select.select_textobject("@comment.outer", "textobjects")
			end)

			vim.keymap.set({ "x", "o" }, "ir", function()
				select.select_textobject("@return.inner", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ar", function()
				select.select_textobject("@return.outer", "textobjects")
			end)

			vim.keymap.set({ "x", "o" }, "i=", function()
				select.select_textobject("@assignment.inner", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "a=", function()
				select.select_textobject("@assignment.outer", "textobjects")
			end)
		end,
	},
}
