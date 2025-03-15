-- Terminal
vim.api.nvim_create_autocmd({ "WinNew", "BufNew" }, {
	callback = function()
		if vim.bo.buftype == "terminal" then
			vim.cmd("startinsert")
		end
	end,
})
