return {
	"hrsh7th/nvim-cmp",
	version = false, -- last release is way too old
	event = "InsertEnter",
	dependencies = {
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"saadparwaiz1/cmp_luasnip",
	},

	config = function()
		vim.diagnostic.config({
			signs = false,
		})
		local cmp = require("cmp")
		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<Tab>"] = cmp.mapping.select_next_item(),
				["<S-Tab>"] = cmp.mapping.select_prev_item(),
				["<Esc>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
			}),

			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "luasnip" },
				{ name = "obsidian" },
				{ name = "obsidian_new" },
				{ name = "obsidian_tags" },
				{ name = "supermaven" },
				{ name = "luasnip" },
				{ name = "cmdline" },
				{ name = "path" },
				{ name = "buffer" },
				{ name = "nvim_lsp:lua_ls" },
			}, {
				{ name = "buffer" },
			}),
		})

		-- Set up lspconfig capabilities
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Set up your language servers here
		local lspconfig = require("lspconfig")
		lspconfig.pyright.setup({
			capabilities = capabilities,
		})
		lspconfig.matlab_ls.setup({
			capabilities = capabilities,
		})
		lspconfig.lua_ls.setup({
			capabilities = capabilities,
		})
	end,
}
