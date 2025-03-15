local vim = vim
vim.g.DiaryMode = false
vim.g.Margin = false

DiaryWindows = {}
DiaryBuffers = {}
local session_file = vim.fn.stdpath("cache") .. "/diary_sesion.vim"
local RunRunning = false
local UpdateRunning = false

function DiaryModeRun()
	RunRunning = true
	-- Save the session_file for later
	vim.cmd("mksession! " .. session_file)

	-- Close all buffers
	local bufs = vim.api.nvim_list_bufs()
	for _, buf in ipairs(bufs) do
		vim.api.nvim_buf_delete(buf, { force = true })
	end

	-- UpdateRunning is to prevent the function DiaryModeUpdate() from running
	UpdateRunning = true
	vim.cmd("ObsidianToday")
	DiaryWindows.today = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_option(DiaryWindows.today, "wrap", true)
	vim.api.nvim_win_set_option(DiaryWindows.today, "linebreak", true)

	vim.defer_fn(function()
		DiaryBuffers.today = vim.api.nvim_get_current_buf()
		vim.cmd("ObsidianYesterday")
		vim.defer_fn(function()
			DiaryBuffers.Yesterday = vim.api.nvim_get_current_buf()
			DiaryWindows.yesterday = vim.api.nvim_open_win(DiaryBuffers.Yesterday, false, { split = "left" })
			UpdateRunning = false
		end, 100)
	end, 100)

	EmptyBuffer = vim.api.nvim_create_buf(false, true)
	DiaryWindows.marginLeft = vim.api.nvim_open_win(EmptyBuffer, false, { split = "left" })
	DiaryWindows.marginRight = vim.api.nvim_open_win(EmptyBuffer, false, { split = "right" })

	vim.api.nvim_win_set_option(DiaryWindows.marginLeft, "number", false)
	vim.api.nvim_win_set_option(DiaryWindows.marginLeft, "relativenumber", false)
	vim.api.nvim_win_set_option(DiaryWindows.marginRight, "number", false)
	vim.api.nvim_win_set_option(DiaryWindows.marginRight, "relativenumber", false)

	RunRunning = false
end

function DiaryModeStop()
	CloseBuffersWithoutSession()
	-- Restore the saved session
	if vim.fn.filereadable(session_file) == 1 then
		print("Restoreing previous session")
		vim.cmd("source " .. session_file)
	else
		print("No session file found!")
	end
end

local function updateMarginWin(margin)
	if margin == 0 then
		if DiaryWindows.marginLeft == nil or vim.api.nvim_win_is_valid(DiaryWindows.marginLeft) then
			vim.api.nvim_win_close(DiaryWindows.marginLeft, true)
		end
		if not DiaryWindows.marginRight == nil or vim.api.nvim_win_is_valid(DiaryWindows.marginRight) then
			vim.api.nvim_win_close(DiaryWindows.marginRight, true)
		end
	else
		if DiaryWindows.marginLeft == nil or not vim.api.nvim_win_is_valid(DiaryWindows.marginLeft) then
			DiaryWindows.marginLeft = vim.api.nvim_open_win(EmptyBuffer, false, { split = "left", width = margin })
			vim.api.nvim_win_set_option(DiaryWindows.marginLeft, "number", false)
			vim.api.nvim_win_set_option(DiaryWindows.marginLeft, "relativenumber", false)
		else
			vim.api.nvim_win_set_width(DiaryWindows.marginLeft, margin)
		end
		if DiaryWindows.marginRight == nil or not vim.api.nvim_win_is_valid(DiaryWindows.marginRight) then
			DiaryWindows.marginRight = vim.api.nvim_open_win(EmptyBuffer, false, { split = "right", width = margin })
			vim.api.nvim_win_set_option(DiaryWindows.marginRight, "number", false)
			vim.api.nvim_win_set_option(DiaryWindows.marginRight, "relativenumber", false)
		else
			vim.api.nvim_win_set_width(DiaryWindows.marginRight, margin)
		end
	end
end

function DiaryModeUpdate()
	print("DiaryModeUpdate")
	if RunRunning or UpdateRunning then
		print("Its not my time to shine yet")
		return
	end

	UpdateRunning = true
	local total_columns = vim.o.columns
	local margin

	vim.api.nvim_win_set_buf(DiaryWindows.today, DiaryBuffers.today)

	if total_columns > 160 then
		margin = math.floor((total_columns - 160) / 2)
		updateMarginWin(margin)

		-- Open yesterday
		if not vim.api.nvim_win_is_valid(DiaryWindows.yesterday) then
			print("Creating window for yesterday")
			DiaryWindows.yesterday =
				vim.api.nvim_open_win(DiaryBuffers.Yesterday, false, { split = "left", width = 80 })
			vim.api.nvim_win_set_option(DiaryWindows.yesterday, "wrap", true)
			vim.api.nvim_win_set_option(DiaryWindows.yesterday, "linebreak", true)
		else
			vim.api.nvim_win_set_width(DiaryWindows.yesterday, 80)
		end
	elseif total_columns > 80 then
		margin = math.floor((total_columns - 80) / 2)
		updateMarginWin(margin)

		-- Close yesterday
		if not DiaryWindows.yesterday == nil or vim.api.nvim_win_is_valid(DiaryWindows.yesterday) then
			vim.api.nvim_win_close(DiaryWindows.yesterday, true)
			-- Move cursor to end of buffer
			-- Enter insert mode
			local lines = vim.api.nvim_buf_line_count(DiaryBuffers.today)
			vim.api.nvim_win_set_cursor(DiaryWindows.today, { lines, 0 })
		end
	else
		updateMarginWin(0)

		-- Close yesterday
		if not DiaryWindows.yesterday == nil or vim.api.nvim_win_is_valid(DiaryWindows.yesterday) then
			vim.api.nvim_win_close(DiaryWindows.yesterday, true)
			-- Move cursor to end of buffer
			-- Enter insert mode
			local lines = vim.api.nvim_buf_line_count(DiaryBuffers.today)
			vim.api.nvim_win_set_cursor(DiaryWindows.today, { lines, 0 })
		end
	end
	UpdateRunning = false
end

function CloseBuffersWithoutSession()
	local bufs = vim.api.nvim_list_bufs()
	for _, buf in ipairs(bufs) do
		local buf_name = vim.api.nvim_buf_get_name(buf)
		if buf_name ~= session_file then
			-- Delete buffers except the session buffer
			vim.api.nvim_buf_delete(buf, { force = true })
		end
	end
end

vim.api.nvim_create_user_command("DiaryModeToggle", function()
	vim.g.DiaryMode = not vim.g.DiaryMode
	if vim.g.DiaryMode then
		DiaryModeRun()
	else
		DiaryModeStop()
	end
end, {})

vim.api.nvim_create_autocmd({ "WinResized" }, {
	callback = function()
		if vim.g.DiaryMode then
			DiaryModeUpdate()
		end
	end,
})
