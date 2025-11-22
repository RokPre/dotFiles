return {
	cmd = { "uv", "run", "pyrefly", "lsp" },
	filetypes = { "python" },
	settings = {},
	on_exit = function(code, _, _)
		vim.notify("Pyrefly exited with code: " .. code, vim.log.levels.INFO)
	end,
	flags = {
		exit_timeout = 5000,
	},
}
