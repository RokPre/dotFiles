-- ✅ feature complete
local keymap = vim.keymap.set
local entered_buffers = {}

local function is_valid(buf)
	return vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) and vim.fn.buflisted(buf) == 1
end

-- Track buffers in history on BufEnter
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function(args)
		local bufnr = args.buf
		if not is_valid(bufnr) then
			return
		end

		for i, b in ipairs(entered_buffers) do
			if b == bufnr then
				table.remove(entered_buffers, i)
				break
			end
		end

		table.insert(entered_buffers, 1, bufnr)
	end,
})

local function close_buffer()
	local current = vim.api.nvim_get_current_buf()

	for i, b in ipairs(entered_buffers) do
		if b == current then
			table.remove(entered_buffers, i)
			break
		end
	end

	local target_buf = nil
	for i, b in ipairs(entered_buffers) do
		if is_valid(b) then
			target_buf = b
			table.remove(entered_buffers, i)
			break
		end
	end

	if target_buf then
		vim.api.nvim_set_current_buf(target_buf)
	else
		vim.notify("No valid previous buffer, closing anyway.", vim.log.levels.WARN)
	end
	vim.api.nvim_buf_delete(current, { force = true })
end

keymap({ "n", "i" }, "<C-w>", close_buffer, { noremap = true, silent = true })

pcall(vim.api.nvim_del_keymap, "n", "<C-W><C-d>")
pcall(vim.api.nvim_del_keymap, "n", "<C-W>d")
