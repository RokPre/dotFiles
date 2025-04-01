local opts = { silent = true, noremap = true, buffer = true }
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown" },
	callback = function()
		vim.keymap.set("n", "<C-c>", ":lua require('toggle-checkbox').toggle()<CR>", opts)
		vim.keymap.set("i", "<C-c>", "<Esc>:lua require('toggle-checkbox').toggle()<CR>i", opts)
		vim.keymap.set("n", "<C-A-h>", "<Cmd>bprev<Cr>", opts)
		vim.keymap.set("n", "<C-A-l>", "<Cmd>bnext<Cr>", opts)
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.spell = false
	end,
})
