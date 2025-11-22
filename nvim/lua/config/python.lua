local version = vim.version()
if version.major > 0 or (version.major == 0 and version.minor >= 11) then
	-- Pyrefly bin: "../../../lsp/bin/pyrefly"
	vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.expand("~/sync/bin/lsp")
	vim.lsp.enable({ "pyrefly" })
end
