local vim = vim
vim.g.focusMode = false
local Windows = {}
local Buffers = {}
local Flags = {}

function FocusModeRun()
	if Flags.run or Flags.stop or Flags.update or Flags.scheduledRunning then
		print("Something has horibly gone wrong")
		return
	end

	Flags.run = true
	print("Entering focus mode")

	Windows.current_win = vim.api.nvim_get_current_win()
	Buffers.current_buf = vim.api.nvim_get_current_buf()
	Buffers.Empty = vim.api.nvim_create_buf(false, true)

	-- Close other windows only if there is more than one window
	local windows = vim.api.nvim_list_wins()
	if #windows > 1 then
		for _, win in ipairs(windows) do
			if win ~= Windows.current_win then
				if vim.api.nvim_win_is_valid(win) then
					vim.api.nvim_win_close(win, true)
				end
			end
		end
	end

	-- Calculates the width for the margin windows
	local total_width = vim.o.columns

	local current_win_width = 80
	if vim.g.focusModeSize ~= nil then
		current_win_width = vim.g.focusModeSize
	end
	-- For line numbers
	local padding = 0
	if vim.g.focusModePadding ~= nil then
		padding = vim.g.focusModePadding
	end
	current_win_width = current_win_width + padding
	local marginLeft = math.floor((total_width - current_win_width) / 2)
	local marginRight = math.ceil((total_width - current_win_width) / 2)

	if total_width > current_win_width then
		Windows.marginLeft = Open_margin(marginLeft, "left")
		Windows.marginRight = Open_margin(marginRight, "right")
	else
		Windows.marginLeft = nil
		Windows.marginRight = nil
	end

	Flags.run = false
end

function FocusModeStop()
	if Flags.run then
		return
	end
	print("Exiting focus mode")

	Flags.stop = true
	vim.g.focusMode = false

	if Windows.marginLeft and vim.api.nvim_win_is_valid(Windows.marginLeft) then
		vim.api.nvim_win_close(Windows.marginLeft, true)
	end
	if Windows.marginRight and vim.api.nvim_win_is_valid(Windows.marginRight) then
		vim.api.nvim_win_close(Windows.marginRight, true)
	end
	Flags.stop = false
end

function FocusModeUpdate()
	if Flags.run or Flags.stop or Flags.update or Flags.scheduledRunning then
		return
	end

	Flags.update = true

	local total_width = vim.o.columns
	local current_win_width = 80
	if vim.g.focusModeSize ~= nil then
		current_win_width = vim.g.focusModeSize
	end
	-- For line numbers
	local padding = 0
	if vim.g.focusModePadding ~= nil then
		padding = vim.g.focusModePadding
	end
	current_win_width = current_win_width + padding
	local marginLeft = math.floor((total_width - current_win_width) / 2)
	local marginRight = math.ceil((total_width - current_win_width) / 2)

	local win_list = {}

	if total_width > current_win_width then
		win_list = { Windows.current_win, Windows.marginLeft, Windows.marginRight }
	else
		win_list = { Windows.current_win }
	end

	-- Closes all windows that are not in the win_list.
	local windows = vim.api.nvim_list_wins()
	for _, win in ipairs(windows) do
		if not vim.tbl_contains(win_list, win) then
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
		end
	end

	-- Checks if any of the windows in the win_list are not valid. Will open them later.
	local need_open = false
	for _, win in ipairs(win_list) do
		if not vim.api.nvim_win_is_valid(win) then
			need_open = true
			break
		end
	end

	if need_open then
		Flags.scheduledRunning = true
		vim.schedule(function()
			if #win_list > 1 then
				if not vim.api.nvim_win_is_valid(win_list[2]) then
					print("maring Left: ", marginLeft)
					Windows.marginLeft = Open_margin(marginLeft, "left")
				end
				if not vim.api.nvim_win_is_valid(win_list[3]) then
					print("maring Right: ", marginRight)
					Windows.marginRight = Open_margin(marginRight, "right")
				end
			end

			if not vim.api.nvim_win_is_valid(win_list[1]) then
				vim.api.nvim_set_current_win(Windows.marginLeft)
				Windows.current_win = vim.api.nvim_open_win(Buffers.current_buf, false, { split = "right" })
			end

			Flags.scheduledRunning = false
		end)
	end

	print("More than one window: ", #win_list > 1)
	print("not scheduledRunning: ", not Flags.scheduledRunning)
	print(#win_list > 1 and not Flags.scheduledRunning)
	if #win_list > 1 and not Flags.scheduledRunning then
		print("Test")
		-- Window resizing
		if vim.api.nvim_win_is_valid(win_list[2]) then
			print("maring Left: ", marginLeft)
			vim.api.nvim_win_set_width(win_list[2], marginLeft)
		end
		if vim.api.nvim_win_is_valid(win_list[3]) then
			print("maring Right: ", marginRight)
			vim.api.nvim_win_set_width(win_list[3], marginRight)
		end

		-- Window reordering
		if vim.api.nvim_win_is_valid(Windows.marginRight) then
			if vim.api.nvim_win_get_position(Windows.marginRight)[2] ~= marginLeft + current_win_width then
				vim.api.nvim_set_current_win(Windows.marginRight)
				vim.cmd("wincmd L")
			end
		end
		if vim.api.nvim_win_is_valid(Windows.marginLeft) then
			if vim.api.nvim_win_get_position(Windows.marginLeft)[2] ~= 0 then
				vim.api.nvim_set_current_win(Windows.marginLeft)
				vim.cmd("wincmd H")
			end
		end
		-- Always set active window to the current window
		if vim.api.nvim_win_is_valid(Windows.current_win) then
			vim.api.nvim_set_current_win(Windows.current_win)
		end
	end

	-- Finishing touches
	local current_buf = vim.api.nvim_get_current_buf()
	if current_buf ~= Buffers.Empty then
		Buffers.current_buf = current_buf
	end
	Flags.update = false
end

function Open_margin(margin, pos)
	return vim.api.nvim_open_win(
		Buffers.Empty,
		false,
		{ split = pos, width = margin, focusable = false, style = "minimal" }
	)
end

vim.api.nvim_create_user_command("FocusMode", function()
	if vim.g.DiaryMode then
		print("Diary Mode is running, please disable it before using Focus Mode")
		return
	end
	vim.g.focusMode = not vim.g.focusMode
	if vim.g.focusMode then
		FocusModeRun()
	else
		FocusModeStop()
	end
end, {})

vim.api.nvim_create_user_command("FocusModeSize", function(opts)
	vim.g.focusModeSize = tonumber(opts.args) or 80
	if vim.g.focusMode then
		FocusModeUpdate()
	end
end, { nargs = 1 })

vim.api.nvim_create_user_command("FocusModePadding", function(opts)
	vim.g.focusModePadding = tonumber(opts.args) or 2
	if vim.g.focusMode then
		FocusModeUpdate()
	end
end, { nargs = 1 })

vim.api.nvim_create_autocmd({ "WinResized", "WinEnter", "WinNew", "BufEnter" }, {
	callback = function()
		if vim.g.focusMode then
			FocusModeUpdate()
		end
	end,
})

local keymap = vim.keymap.set
keymap("n", "č", "<cmd>FocusMode<cr>", { silent = true, noremap = true })
