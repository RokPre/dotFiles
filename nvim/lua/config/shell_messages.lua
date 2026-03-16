local function show_message(msg)
	local buf = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(msg, "\n"))

	vim.bo[buf].modifiable = false
	vim.bo[buf].readonly = true
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].filetype = "message"

	local height = math.floor(vim.o.lines * 0.4)

	local win = vim.api.nvim_open_win(buf, true, { split = "below", win = 0, height = height })

	vim.api.nvim_create_autocmd("BufLeave", {
		buffer = buf,
		once = true,
		callback = function()
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
		end,
	})
end

vim.keymap.set("n", "<leader>!", function()
	local last_cmd = vim.fn.getreg(":")

	if not vim.startswith(last_cmd, "!") then
		vim.notify("Last command was not a shell command")
		return
	end

	local shell_cmd = vim.trim(last_cmd:sub(2))
	local output = vim.fn.system(shell_cmd)

	show_message("$ " .. shell_cmd .. "\n\n" .. output)
end, { desc = "Rerun last shell command in message buffer" })
