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
		"hrsh7th/cmp-emoji",
		"hrsh7th/cmp-calc",
		"chrisgrieser/cmp-nerdfont",
		"saadparwaiz1/cmp_luasnip",
	},

	config = function()
		-- Diagnostic signs off
		vim.diagnostic.config({ signs = false })

		-- nvim-cmp setup
		local cmp = require("cmp")
		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-n>"] = cmp.mapping.select_next_item(),
				["<C-m>"] = cmp.mapping.select_prev_item(),
				["<C-c>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = false }),
			}),
			sources = cmp.config.sources({
				{ name = "buffer" },
				{ name = "calc" },
				-- { name = "cmdline" },
				{ name = "emoji" },
				{ name = "luasnip" },
				{ name = "nerdfont" },
				{ name = "obsidian" },
				{ name = "obsidian_new" },
				{ name = "obsidian_tags" },
				{ name = "path" },
			}, {
				-- fallback sources
			}),
		})

		-- Capabilities for completion
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- ✅ NEW LSP CONFIG STYLE
		vim.lsp.config["pyright"] = {
			capabilities = capabilities,
		}

		vim.lsp.config["matlab_ls"] = {
			capabilities = capabilities,
		}

		vim.lsp.config["lua_ls"] = {
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = { globals = { "vim", "require" } },
					workspace = { library = vim.api.nvim_get_runtime_file("", true) },
					telemetry = { enable = false },
				},
			},
		}

		-- Enable the servers
		vim.lsp.enable("pyright")
		vim.lsp.enable("matlab_ls")
		vim.lsp.enable("lua_ls")
	end,
}
