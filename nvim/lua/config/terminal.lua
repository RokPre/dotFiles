local keymap = vim.keymap.set
local opts = { silent = true, noremap = true }

function openOrSwitchTerm()
	-- Check if a terminal is already open in any window
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].buftype == "terminal" then
			vim.api.nvim_set_current_win(win) -- Switch to terminal window
			-- print("Terminal already open in another window")
			return
		end
	end
	-- Check if a terminal buffer exists
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[buf].buftype == "terminal" then
			vim.cmd("buffer " .. buf) -- Switch to existing terminal buffer
			-- print("Terminal already open in another buffer")
			return
		end
	end
	vim.cmd("terminal")
end

-- Correct way to set the keymap
keymap("n", "<A-t>", ":lua openOrSwitchTerm()<CR>", opts)
keymap("t", "<A-t>", "<C-\\><C-n>", opts)
keymap("t", "<Esc>", "<C-\\><C-n>", opts)

vim.api.nvim_create_autocmd({ "WinNew", "BufNew" }, {
	callback = function()
		if vim.bo.buftype == "terminal" then
			vim.cmd("startinsert")
		end
	end,
})
