local version = vim.version()

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

local ok, _ = pcall(require, "mason")
if ok then
	local cfg = require("mason.settings").current
	local ensure = cfg.ensure_installed or {}

	if version.major > 0 or (version.major == 0 and version.minor >= 11) then
		vim.list_extend(ensure, {
			"basedpyright",
		})
	else
		vim.list_extend(ensure, {
			"pyrefly",
		})
	end

	cfg.ensure_installed = ensure

	local mr_ok, mr = pcall(require, "mason-registry")
	if mr_ok then
		vim.defer_fn(function()
			mr.refresh(function()
				for _, tool in ipairs(cfg.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end)
		end, 100)
	end
end

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

	return {}
else
	return {
		"neovim/nvim-lspconfig",
    dependencies = "folke/lazydev.nvim",
    config = function()
      require("lspconfig").lua_ls.setup({
        settings= {
          Lua = {
            diagnostics = {
              globals = { "vim", "require" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true)
            }
          }
        }
      })
			require("lspconfig").pyrefly.setup({})
		end,
	}
end
