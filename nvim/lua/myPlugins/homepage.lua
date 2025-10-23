local M = {}

local lines_raw = {}
local header_lines = {}
local callbacks = {}

function M.set_header(lines)
	if type(lines) == "string" then
		header_lines = vim.split(lines, "\n", { plain = true })
	elseif type(lines) == "table" then
		header_lines = lines
	else
		error("Header must be string or list of strings")
	end
end

function M.add_line(icon, text, key, fn)
	table.insert(lines_raw, { icon = icon, text = text, key = key })
	callbacks[key] = fn
end

function M.set_keys(key_table)
	for _, entry in ipairs(key_table) do
		local icon = entry.icon or "󰈚"
		local desc = entry.desc or "Missing desc"
		local key = entry.key or "?"
		local action = entry.action

		local callback
		if type(action) == "function" then
			callback = action
		elseif type(action) == "string" then
			callback = function()
				vim.cmd(action)
			end
		else
			error("Action for key '" .. key .. "' must be a string or function")
		end

		M.add_line(icon, desc, key, callback)
	end
end

local function format_homepage()
	-- Measure widths for alignment
	local max_icon_len = 0
	local max_text_len = 0
	for _, item in ipairs(lines_raw) do
		local icon_width = vim.fn.strwidth(item.icon)
		local text_width = vim.fn.strwidth(item.text)

		if icon_width > max_icon_len then
			max_icon_len = icon_width
		end
		if text_width > max_text_len then
			max_text_len = text_width
		end
	end
	-- Format aligned shortcut lines
	local formatted_shortcuts = {}
	local total_line_width = 0

	for _, item in ipairs(lines_raw) do
		local icon_pad = string.rep(" ", max_icon_len - vim.fn.strwidth(item.icon))
		local text_pad = string.rep(" ", max_text_len - vim.fn.strwidth(item.text))
		local line = string.format("%s%s   %s%s   [%s]", icon_pad, item.icon, item.text, text_pad, item.key)
		table.insert(formatted_shortcuts, { line = line, key = item.key, callback = callbacks[item.key] })
		if #line > total_line_width then
			total_line_width = #line
		end
	end
	-- Format header lines
	local formatted_headers = {}
	local max_header_len = 0
	for _, line in ipairs(header_lines) do
		table.insert(formatted_headers, line)
		if #line > max_header_len then
			max_header_len = #line
		end
	end

	local win_height = vim.api.nvim_win_get_height(0)
	local win_width = vim.api.nvim_win_get_width(0)
	local line_count = #formatted_headers + #formatted_shortcuts + 1
	local vertical_padding = math.floor((win_height - line_count) / 2)
	local lines_to_display = {}

	for _ = 1, vertical_padding do
		table.insert(lines_to_display, "")
	end

	-- Align headers as a block
	local header_margin = math.floor((win_width - max_header_len) / 2)
	for _, line in ipairs(formatted_headers) do
		local pad = math.floor((max_header_len - #line) / 2)
		table.insert(lines_to_display, string.rep(" ", math.max(header_margin + pad, 0)) .. line)
	end

	table.insert(lines_to_display, "")

	-- Align shortcuts as a block
	local shortcut_margin = math.floor((win_width - total_line_width) / 2)
	for _, item in ipairs(formatted_shortcuts) do
		table.insert(lines_to_display, string.rep(" ", math.max(shortcut_margin, 0)) .. item.line)
	end
	return lines_to_display, formatted_shortcuts
end

function M.open()
	local homepage_buf = vim.api.nvim_create_buf(false, true)

	-- Set the homepage as the current buffer
	vim.api.nvim_set_current_buf(homepage_buf)

	-- Delete the initial buffer that is shown when nvim is launched without a file
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if
			vim.api.nvim_buf_is_valid(buf)
			and vim.api.nvim_buf_get_name(buf) == ""
			and vim.api.nvim_buf_get_option(buf, "modifiable")
			and #vim.api.nvim_buf_get_lines(buf, 0, -1, false) == 1
			and vim.api.nvim_buf_get_lines(buf, 0, -1, false)[1] == ""
			and buf ~= homepage_buf
		then
			vim.api.nvim_buf_delete(buf, { force = true })
			-- vim.notify("Deleted initial [No Name] buffer", vim.log.levels.INFO)
		end
	end

	-- Set the options of the homepage window
	local homepage_win = vim.api.nvim_get_current_win()
	vim.api.nvim_set_option_value("wrap", false, { win = homepage_win })
	vim.api.nvim_set_option_value("number", false, { win = homepage_win })
	vim.api.nvim_set_option_value("relativenumber", false, { win = homepage_win })
	vim.api.nvim_set_option_value("cursorline", true, { win = homepage_win })

	local lines_to_display, formatted_shortcuts = format_homepage()
	vim.api.nvim_buf_set_lines(homepage_buf, 0, -1, false, lines_to_display)

	for _, item in ipairs(formatted_shortcuts) do
		vim.keymap.set("n", item.key, item.callback, {
			buffer = homepage_buf,
			nowait = true,
			noremap = true,
			silent = true,
		})
	end

	-- Set the options of the homepage buffer
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = homepage_buf })
	vim.api.nvim_set_option_value("modifiable", false, { buf = homepage_buf })

	vim.api.nvim_create_autocmd("BufEnter", {
		callback = function()
			if
				homepage_win
				and vim.api.nvim_win_is_valid(homepage_win)
				and vim.api.nvim_win_get_buf(homepage_win) ~= homepage_buf
			then
				vim.api.nvim_set_option_value("wrap", true, { win = homepage_win })
				vim.api.nvim_set_option_value("number", true, { win = homepage_win })
				vim.api.nvim_set_option_value("relativenumber", true, { win = homepage_win })
				vim.api.nvim_set_option_value("cursorline", false, { win = homepage_win })
			end
		end,
	})

	vim.api.nvim_create_autocmd("WinResized", {
		buffer = homepage_buf,
		callback = function()
			lines_to_display, _ = format_homepage()
			vim.api.nvim_set_option_value("modifiable", true, { buf = homepage_buf })
			vim.api.nvim_buf_set_lines(homepage_buf, 0, -1, false, lines_to_display)
			vim.api.nvim_set_option_value("modifiable", false, { buf = homepage_buf })
		end,
	})
end

local builtin = require("telescope.builtin")

local header = [[
    _   __            _    __ _          
   / | / /___   ____ | |  / /(_)____ ___ 
  /  |/ // _ \ / __ \| | / // // __ `__ \
 / /|  //  __// /_/ /| |/ // // / / / / /
/_/ |_/ \___/ \____/ |___//_//_/ /_/ /_/ 
]]

M.set_header(header)

M.set_keys({
	{ icon = " ", key = "f", desc = "Find File", action = builtin.find_files },
	{ icon = " ", key = "r", desc = "Recent Files", action = builtin.oldfiles },
	{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
	{
		icon = "󰊔 ",
		key = "h",
		desc = "Close",
		action = function()
			vim.cmd(":try | b# | catch | ;")
		end,
	},
	{ icon = " ", key = "g", desc = "Find Text", action = builtin.live_grep },
	{
		icon = " ",
		key = "p",
		desc = "Project Explorer",
		action = function()
			vim.cmd("ProjectManager")
		end,
	},
	{
		icon = " ",
		key = "c",
		desc = "Config",
		action = function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end,
	},
	{
		icon = " ",
		key = "s",
		desc = "Restore Session",
		action = function()
			vim.cmd("LastSession")
		end,
	},
	{ icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
	{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
})

vim.api.nvim_create_user_command("Homepage", function()
	M.open()
end, {})

vim.keymap.set("n", "<Leader>h", function()
	M.open()
end, { noremap = true, silent = true })

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		-- M.open()
		vim.schedule(function()
			if #vim.fn.argv() == 0 then
				M.open()
			end
		end)
	end,
})
