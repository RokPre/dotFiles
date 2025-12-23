-- TODO: https://chatgpt.com/g/g-p-68f6214d376c8191bab3c705a7729b6f-dotfiles/shared/c/69051466-f370-8328-b194-330e80e68d28?owner_user_id=user-zAOyDfoGfoo7lCKjae2iBIwx
-- TODO: When seting the opts for the homepage window and buffer, get the current user config, and the when unseting them revert tot he original user config.
-- TODO: Use global homepage win in all functions
local M = {}

M.home_buf = vim.api.nvim_create_buf(false, true)
M.home_win = nil

M.opts = {}

M.opts.top_padding = "auto"
M.opts.mid_padding = "auto"
M.opts.actions_header_aligh = true

M.opts.header = [[
    _   __            _    __ _          
   / | / /___   ____ | |  / /(_)____ ___ 
  /  |/ // _ \ / __ \| | / // // __ `__ \
 / /|  //  __// /_/ /| |/ // // / / / / /
/_/ |_/ \___/ \____/ |___//_//_/ /_/ /_/ 
]]

M.opts.actions = {}

local ok_telescope, builtin = pcall(require, "telescope.builtin")
if ok_telescope then
	table.insert(M.opts.actions, {
		icon = " ",
		key = "f",
		desc = "Find File",
		action = builtin.find_files,
	})
	table.insert(M.opts.actions, {
		icon = " ",
		key = "g",
		desc = "Find Text",
		action = builtin.live_grep,
	})
	table.insert(M.opts.actions, {
		icon = " ",
		key = "r",
		desc = "Recent Files",
		action = builtin.oldfiles,
	})
	table.insert(M.opts.actions, {
		icon = " ",
		key = "c",
		desc = "Config",
		action = function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end,
	})
end

local ok_pm, projectManager = pcall(require, "myPlugins.projectManager")
if ok_pm and projectManager and projectManager.show_projects then
	table.insert(M.opts.actions, {
		icon = " ",
		key = "p",
		desc = "Project Explorer",
		action = projectManager.show_projects,
	})
end

local ok, sessionManager = pcall(require, "myPlugins.sessionManager")
if ok and sessionManager.loadLastSession then
	table.insert(M.opts.actions, {
		icon = " ",
		key = "s",
		desc = "Restore Session",
		action = sessionManager.loadLastSession,
	})
end

table.insert(M.opts.actions, {
	icon = " ",
	key = "n",
	desc = "New File",
	action = function()
		vim.cmd(":ene | startinsert")
	end,
})
table.insert(M.opts.actions, {
	icon = "󰊔 ",
	key = "h",
	desc = "Close",
	action = function()
		vim.api.nvim_set_current_buf(M.Current_buf)
	end,
})

table.insert(M.opts.actions, {
	icon = " ",
	key = "q",
	desc = "Quit",
	action = function()
		vim.cmd(":qa")
	end,
})

local function get_homepage_win()
	local wins = vim.api.nvim_tabpage_list_wins(0)

	for _, win in ipairs(wins) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.api.nvim_buf_is_valid(buf) and buf == M.home_buf and vim.api.nvim_win_is_valid(win) then
			M.home_win = win
			return
		end
	end
	M.home_win = nil
	return
end

local function format_homepage()
	-- Convert header from string to list of llines [string]
	local header_lines = vim.split(M.opts.header, "\n", { plain = true })

	-- Get height of the window
	local win_height = vim.api.nvim_win_get_height(M.home_win)
	local win_width = vim.api.nvim_win_get_width(M.home_win)

	-- If the user does not specify the padding, calculate it
	if M.opts.mid_padding == nil or M.opts.mid_padding == "auto" then
		M.opts.mid_padding = math.floor((#header_lines + #M.opts.actions) / 10)
	end

	if M.opts.top_padding == nil or M.opts.top_padding == "auto" then
		local line_count = #header_lines + #M.opts.actions + M.opts.mid_padding
		M.opts.top_padding = math.floor((win_height - line_count) / 2)
	end

	-- Element vertical ranges
	local top_padding_range = { 0, M.opts.top_padding }
	local header_range = { top_padding_range[2] + 1, top_padding_range[2] + #header_lines }
	local middle_padding_range = { header_range[2] + 1, header_range[2] + M.opts.mid_padding }
	local keys_range = { middle_padding_range[2] + 1, middle_padding_range[2] + 1 + #M.opts.actions }

	-- Create the lines that will be displayed
	local homepage_lines = {}
	local line = ""

	for _ = top_padding_range[1], top_padding_range[2] do
		table.insert(homepage_lines, "")
	end

	-- Find the max width of the header lines
	local max_header_len = 0
	for _, header_line in ipairs(header_lines) do
		if #header_line > max_header_len then
			max_header_len = #header_line
		end
	end

	local left_padding = math.floor((win_width - max_header_len) / 2)

	for index = 1, header_range[2] - header_range[1] do
		line = string.rep(" ", left_padding) .. header_lines[index]
		table.insert(homepage_lines, line)
	end

	for _ = middle_padding_range[1], middle_padding_range[2] do
		table.insert(homepage_lines, "")
	end

	-- Find the max width of the actions
	local max_action_len = 0
	if M.opts.actions_header_aligh then
		max_action_len = max_header_len -- Make actions the same width as header
	else
		for _, action in ipairs(M.opts.actions) do
			if #action.key + #action.desc > max_action_len then
				max_action_len = #action.key + #action.desc
			end
		end
	end

	left_padding = math.floor((win_width - max_action_len) / 2)

	for index = 1, keys_range[2] - keys_range[1] do
		local key_spacing = max_action_len - 1 - 1 - #M.opts.actions[index].desc - #" [" - #M.opts.actions[index].key - #"]"
		line = string.rep(" ", left_padding) .. M.opts.actions[index].icon .. M.opts.actions[index].desc .. string.rep(" ", key_spacing) .. " [" .. M.opts.actions[index].key .. "]"
		table.insert(homepage_lines, line)
	end

	vim.api.nvim_set_option_value("modifiable", true, { buf = M.home_buf })
	vim.api.nvim_buf_set_lines(M.home_buf, 0, -1, false, homepage_lines)
	vim.api.nvim_set_option_value("modifiable", false, { buf = M.home_buf })
end

local function add_actions()
	-- Buffer is not valid. Can't add actions to buffer that is not valid.
	if not (M.home_buf and vim.api.nvim_buf_is_valid(M.home_buf)) then
		vim.notify("Homepage buffer is not valid — skipping add_actions()")
		return
	end

	for _, action in ipairs(M.opts.actions) do
		vim.keymap.set("n", action.key, function()
			action.action()
		end, { noremap = true, silent = true, buffer = M.home_buf })
	end
end

local function set_options()
	-- Find the window with the homepage buffer
	get_homepage_win()

	if M.home_win ~= nil and vim.api.nvim_win_is_valid(M.home_win) then
		vim.api.nvim_set_option_value("relativenumber", false, { win = M.home_win })
		vim.api.nvim_set_option_value("number", false, { win = M.home_win })
	end
end

local function unset_options()
	-- If found a window with the homepage buffer set the options
	vim.api.nvim_set_option_value("relativenumber", true, { win = M.home_win })
	vim.api.nvim_set_option_value("number", true, { win = M.home_win })
end

function M.open()
	-- If buffer was closed, create a new onw
	if M.home_buf == nil or not vim.api.nvim_buf_is_valid(M.home_buf) then
		M.home_buf = vim.api.nvim_create_buf(false, true)
	end

	-- Focus one the homepage window/buffer
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == M.home_buf then
			vim.api.nvim_set_current_win(win)
			return -- stop here; we already focused the homepage
		end
	end

	-- Get current buffer
	M.Current_buf = vim.api.nvim_get_current_buf()

	vim.api.nvim_create_autocmd({ "BufLeave", "SessionLoadPost", "BufEnter" }, {
		callback = function()
			-- Update the M.homw_win. Checks if homepage buffer is open in any window.
			get_homepage_win()

			if M.home_win ~= nil then
				-- Homepage window is not nil, which means that homepage is stil open, therefore do not unset the options.
				-- vim.notify("Homepage is open. Do not unset options.")
				return
			end

			unset_options()
		end,
	})

	vim.api.nvim_create_autocmd("WinNew", {
		desc = "Ensure homepage buffer is only visible in one window",
		callback = function()
			if not (M.home_buf and vim.api.nvim_buf_is_valid(M.home_buf)) then
				-- vim.notify("Homepage buffer is not valid. Can't close extra windows.")
				return
			end

			-- Schedule to avoid interfering with window creation
			vim.schedule(function()
				local wins = vim.api.nvim_tabpage_list_wins(0)
				local homepage_wins = {}

				-- Find all windows showing the homepage buffer
				for _, win in ipairs(wins) do
					local buf = vim.api.nvim_win_get_buf(win)
					if buf == M.home_buf and vim.api.nvim_win_is_valid(win) then
						table.insert(homepage_wins, win)
					end
				end

				-- Keep the original, close any extras
				for _, win in ipairs(homepage_wins) do
					if win ~= M.home_win then
						pcall(vim.api.nvim_win_close, win, true)
					end
				end
			end)
		end,
	})

	vim.api.nvim_create_autocmd("WinResized", {
		callback = function()
			-- Find the window with the buffer M.home_buf
			get_homepage_win()

			if M.home_win == nil then
				return
			end

			format_homepage()
		end,
	})

	vim.api.nvim_set_current_buf(M.home_buf)
	-- M.home_win = vim.api.nvim_get_current_win()
	get_homepage_win()

	-- Set options for the homepage
	set_options()

	-- Set actions for the homepage buffer
	add_actions()

	-- Format the homepage to look nice
	format_homepage()
end

vim.keymap.set("n", "<Leader>h", function()
	M.open()
end, { noremap = true, silent = true })

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.schedule(function()
			if #vim.fn.argv() == 0 and vim.bo.filetype ~= "lazy" then
				-- Unlist buffers
				local buffers = vim.api.nvim_list_bufs()

				for _, buf in ipairs(buffers) do
					if buf ~= M.home_buf and vim.api.nvim_get_option_value("buflisted", { buf = buf }) then
						vim.api.nvim_set_option_value("buflisted", false, { buf = buf })
					end
				end

				M.open()
			end
		end)
	end,
})

return M
