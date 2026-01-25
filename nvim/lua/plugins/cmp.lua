return {
	"hrsh7th/nvim-cmp",
	version = false,
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-emoji",
		"hrsh7th/cmp-calc",
		"chrisgrieser/cmp-nerdfont",
		"saadparwaiz1/cmp_luasnip",
	},

	config = function()
		local cmp = require("cmp")
		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-,>"] = cmp.mapping.select_next_item(),
				["<C-;>"] = cmp.mapping.select_prev_item(),
				["<C-c>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = false }),
			}),
			sources = cmp.config.sources({
        { name = "luasnip" },
        { name = "path" },
				{ name = "buffer" },
				{ name = "calc" },
				{ name = "emoji" },
				{ name = "nerdfont" },
			}, {
				-- fallback sources
			}),
		})
	end,
}
