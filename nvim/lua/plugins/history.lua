-- This plugin is used to recreate the history behavior of Obsidian and most browsers.
-- Each window has its own history, and you can navigate back and forward through it.
-- If you open a new file by following a link, then you can navigate back to the previous file.
-- You also then navigate forward to the new file.
local nav_history = {} -- Table to store history for each window

-- Function to get window-specific history
local function get_win_history(win_id)
	if not nav_history[win_id] then
		nav_history[win_id] = { stack = {}, index = 0 }
	end
	return nav_history[win_id]
end

-- Function to track file navigation per window
local function track_navigation()
	local win_id = vim.api.nvim_get_current_win() -- Get current window ID
	local history = get_win_history(win_id)
	local current_file = vim.fn.expand("%:p") -- Get full path of current file

	if history.stack[history.index] ~= current_file then
		-- Trim forward history if we went back and then open a new file
		while #history.stack > history.index do
			table.remove(history.stack)
		end
		table.insert(history.stack, current_file)
		history.index = #history.stack
	end
end

-- Function to go back in history for the current window
local function go_back()
	local win_id = vim.api.nvim_get_current_win()
	local history = get_win_history(win_id)

	if history.index > 1 then
		history.index = history.index - 1
		vim.cmd("edit " .. history.stack[history.index])
	end
end

-- Function to go forward in history for the current window
local function go_forward()
	local win_id = vim.api.nvim_get_current_win()
	local history = get_win_history(win_id)

	if history.index < #history.stack then
		history.index = history.index + 1
		vim.cmd("edit " .. history.stack[history.index])
	end
end

-- Autocommand to track file navigation per window
vim.api.nvim_create_autocmd("BufEnter", {
	callback = track_navigation,
})

-- Keybindings (window-specific navigation)
-- vim.keymap.set("n", "<C-A-h>", go_back, { silent = true }) -- Back
-- vim.keymap.set("n", "<C-A-l>", go_forward, { silent = true }) -- Forward
