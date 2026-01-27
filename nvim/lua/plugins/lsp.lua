local version = vim.version()

if version.major > 0 or (version.major == 0 and version.minor >= 11) then
	-- Python lsp
	vim.lsp.config["basedpyright"] = {
		cmd = { "basedpyright-langserver", "--stdio" },
		filetypes = { "python" },
		settings = {
			basedpyright = {
				analysis = {
					autoSearchPaths = true,
					diagnosticMode = "openFilesOnly",
				},
			},
		},
	}

	vim.lsp.enable("basedpyright")

	-- Lua lsp
	vim.lsp.config["luals"] = {
		cmd = { "lua-language-server" },
		filetypes = { "lua" },
		root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
				},
				diagnostics = {
					globals = { "vim" },
				},
			},
		},
	}
	vim.lsp.enable("luals")

	-- Bash lsp
	vim.lsp.config["bashls"] = {
		cmd = { "bash-language-server", "start" },
		settings = {
			bashIde = {
				globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
			},
		},
		filetypes = { "bash", "sh" },
	}

	vim.lsp.enable("bashls")

	-- Diagnostics config
	vim.diagnostic.config({
		virtual_text = {
			spacing = 2,
			prefix = "●",
		},
		signs = false,
		underline = true,
		update_in_insert = false,
	})

	return {}
else
	return {
		"neovim/nvim-lspconfig",
		dependencies = "folke/lazydev.nvim",
		config = function()
			require("lspconfig").lua_ls.setup({})
			require("lspconfig").pyrefly.setup({})
		end,
	}
end
