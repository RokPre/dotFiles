local float_win = nil
local float_augroup = nil
local user_win_close_augroup = nil
local draw_float_qugroup = nil
local SEARCH_STRING_FOR_CURSOR_POS = "# Plan za danes"

local obsidian_ok, _ = pcall(require, "obsidian")

local function move_cursor_to_pattern()
	if not (float_win and vim.api.nvim_win_is_valid(float_win)) then
		vim.notify("Floating diary is not enabled", vim.log.levels.WARN)
		return
	end

	local buf = vim.api.nvim_win_get_buf(float_win)
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

	for index, line in ipairs(lines) do
		local ok, found = pcall(function()
			return line:find(SEARCH_STRING_FOR_CURSOR_POS)
		end)

		if ok and found then
			local row = index
			vim.api.nvim_win_set_cursor(float_win, { row, 0 })
			break
		end
	end
end

local function get_floating_geometry()
	local total_height = vim.o.lines
	local total_width = vim.o.columns
	local height = math.floor(total_height * 0.8)
	local ideal_width = 80
	local width = total_width >= ideal_width and ideal_width or math.floor(total_width * 0.8)
	local row = math.floor((total_height - height) / 2)
	local col = math.floor((total_width - width) / 2)
	return width, height, row, col
end

local function draw_floating_diary()
	if not (float_win and vim.api.nvim_win_is_valid(float_win)) then
		return
	end

	local width, height, row, col = get_floating_geometry()

	vim.api.nvim_win_set_config(float_win, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	})
end

local function unlist_buffer()
	if not (float_win and vim.api.nvim_win_is_valid(float_win)) then
		return
	end
	local buf = vim.api.nvim_win_get_buf(float_win)
	if vim.api.nvim_buf_is_valid(buf) then
		vim.api.nvim_set_option_value("buflisted", false, { buf = buf })
		vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
	end
end

local function disable_floating_diary()
	if float_augroup then
		pcall(function()
			vim.api.nvim_del_augroup_by_id(float_augroup)
		end)
	end
	if draw_float_qugroup then
		pcall(function()
			vim.api.nvim_del_augroup_by_id(draw_float_qugroup)
		end)
	end
	if user_win_close_augroup then
		pcall(function()
			vim.api.nvim_del_augroup_by_id(user_win_close_augroup)
		end)
	end

	if float_win and vim.api.nvim_win_is_valid(float_win) then
		vim.api.nvim_win_close(float_win, true)
	end
	float_win = nil
end

local function enable_floating_diary()
	local float_buf = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = float_buf })

	local width, height, row, col = get_floating_geometry()
	float_win = vim.api.nvim_open_win(float_buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	})

	float_augroup = vim.api.nvim_create_augroup("FloatingDiaryGroup", { clear = true })
	vim.api.nvim_create_autocmd("BufEnter", {
		group = float_augroup,
		callback = function()
			unlist_buffer()
			move_cursor_to_pattern()
		end,
	})

	draw_float_qugroup = vim.api.nvim_create_augroup("DrawGroup", { clear = true })
	vim.api.nvim_create_autocmd("WinResized", {
		group = draw_float_qugroup,
		callback = function()
			draw_floating_diary()
		end,
	})

	user_win_close_augroup = vim.api.nvim_create_augroup("UserWinCloseGroup", { clear = true })
	vim.api.nvim_create_autocmd("WinClosed", {
		group = user_win_close_augroup,
		pattern = tostring(float_win),
		callback = function()
			disable_floating_diary()
		end,
	})

	vim.schedule(function()
		if not (float_win and vim.api.nvim_win_is_valid(float_win)) then
			return
		end
		vim.api.nvim_win_call(float_win, function()
			vim.cmd("Obsidian today")
		end)
	end)
end

local function toggle_float_diary()
	if not obsidian_ok then
		vim.notify("Obsidian is not installed", vim.log.levels.ERROR)
		return
	end

	if float_win and vim.api.nvim_win_is_valid(float_win) then
		if vim.api.nvim_get_current_win() ~= float_win then
			-- If diary is open and another window is focused, switch to diary window
			vim.api.nvim_set_current_win(float_win)
		else
			disable_floating_diary()
		end
		return
	end

	enable_floating_diary()
end

vim.keymap.set("n", "<C-d>", toggle_float_diary, { desc = "Toggle Obsidian Float" })
vim.api.nvim_create_user_command("FloatingDiary", toggle_float_diary, { desc = "Toggle Obsidian Float" })
