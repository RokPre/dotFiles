local version = vim.version()
if version.major > 0 or (version.major == 0 and version.minor >= 11) then
	-- Pyrefly bin: "../../../lsp/bin/pyrefly"
	vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.expand("~/sync/bin/lsp")
	vim.lsp.enable({ "pyrefly" })
else
	okmr, mason_reg = pcall(require, "mason-registry")
	oklsp, lspconfig = pcall(require, "lspconfig")
	okcfg, configs = pcall(require, "lspconfig.configs")

	if not okmr or not oklsp or not okcfg then
		vim.notify("Mason ok: " .. tostring(okmr) .. ", Lsp ok: " .. tostring(oklsp) .. ", Cfg ok: " .. tostring(okcfg))
		return
	end

	if not mason_reg.is_installed("pyrefly") then
		vim.cmd("MasonInstall pyrefly")
	end

	if not configs.pyrefly then
		configs.pyrefly = {
			default_config = {
				cmd = { "pyrefly", "lsp" },
				filetypes = { "python" },
				root_dir = lspconfig.util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", ".git"),
				settings = {},
			},
		}
	end

	lspconfig.pyrefly.setup({})
end
