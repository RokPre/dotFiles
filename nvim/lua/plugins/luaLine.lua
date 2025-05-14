-- Function to get activity based on current time
_G.last_activity = nil
_G.mod_time = nil
_G.last_activity_end_time = nil
local function get_activity()
	local home = os.getenv("HOME")
	local file_name = os.date("%Y - %j", os.time()) .. ".md"
	local path = home .. "/sync/vault/Dnevnik/" .. file_name

	if _G.last_activity and _G.mod_time > vim.loop.fs_stat(path).mtime.sec then
		if _G.last_activity_end_time > os.time() then
			return _G.last_activity
		end
	end

	local start_index, end_index
	local contents = vim.fn.readfile(path)

	if #contents == 0 then
		return "No content available"
	end

	-- Find start and end indexes for the daily plan
	for i, line in ipairs(contents) do
		if line:find("Plan za danes") then
			start_index = i
		end
		if line == "" and start_index then
			end_index = i
			break
		end
	end

	if not start_index or not end_index then
		return "No valid activity found"
	end

	-- Function to check if the current time is within a given activity's time range
  local function is_active(start_time, end_time)
    local time = os.date("*t")
    local hour, minute = time.hour, time.min
    -- local start_hour, start_minute = tonumber(start_time:match("(%d%d)")), tonumber(start_time:match(":(%d%d)"))
    -- local end_hour, end_minute = tonumber(end_time:match("(%d%d)")), tonumber(end_time:match(":(%d%d)"))
    local start_hour, start_minute = start_time:match("^(%d+):(%d%d)$")
    local end_hour, end_minute = end_time:match("^(%d+):(%d%d)$")

    start_hour = tonumber(start_hour)
    start_minute = tonumber(start_minute)
    end_hour = tonumber(end_hour)
    end_minute = tonumber(end_minute)

    local current_minutes = hour * 60 + minute
    local start_minutes = start_hour * 60 + start_minute
    local end_minutes = end_hour * 60 + end_minute

    -- Handle case where the time range spans midnight
    if end_minutes < start_minutes then
      return current_minutes >= start_minutes or current_minutes <= end_minutes
    else
      return current_minutes >= start_minutes and current_minutes <= end_minutes
    end
  end

	local function convert_to_timestamp(time_str)
		-- Assuming time_str is in "HH:MM" format
		local hour, minute = time_str:match("^(%d%d):(%d%d)$")

		-- Get the current date (today's date) using os.date()
		local current_date = os.date("*t")

		-- Create a table with the current year, month, day, and the parsed hour and minute
		local time_table = {
			year = current_date.year,
			month = current_date.month,
			day = current_date.day,
			hour = tonumber(hour),
			min = tonumber(minute),
			sec = 0,
		}

		-- Convert the table to a timestamp
		return os.time(time_table)
	end

	-- Loop through activities and check if they are active
	for i = start_index + 1, end_index - 1 do
    local activity, start_time, end_time = contents[i]:match("%- %[ %] (.-)%s+(%d?%d:%d%d)%s*%-%s*(%d?%d:%d%d)")
    -- vim.print("contents" .. contents[i])
    -- vim.print(activity, start_time, end_time)
		if activity and start_time and end_time and is_active(start_time, end_time) then
			_G.last_activity = activity
			_G.last_activity_end_time = convert_to_timestamp(end_time)
			_G.mod_time = os.time()
			return activity
		end
	end

	-- Default activity if no match found
	_G.last_activity = "Relax"
  _G.last_activity_end_time = os.time() + 60 * 5 -- Refresh every 5 minutes
  _G.mod_time = os.time()

  -- Failsafe if nothing else is found
	return "Relax"
end

-- Lualine configuration
return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
				globalstatus = true,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				theme = "auto",
			},
			tabline = {},
			sections = {
				lualine_a = { "branch" },
				lualine_b = { "diff" },
				lualine_c = {},
				lualine_x = {
					"filename",
					function()
						return vim.fn.expand("%:p:h")
					end,
					"data",
				},
				lualine_y = {
					function()
						-- Get the current activity
						local activity = get_activity()
						return activity
					end,
					"data",
				},
				lualine_z = {
					function()
						local time = os.date("*t")
						local hour = time.hour
						local minute = time.min

						local Hours = {
							"Midnight",
							"One",
							"Two",
							"Three",
							"Four",
							"Five",
							"Six",
							"Seven",
							"Eight",
							"Nine",
							"Ten",
							"Eleven",
							"Noon",
							"One",
							"Two",
							"Three",
							"Four",
							"Five",
							"Six",
							"Seven",
							"Eight",
							"Nine",
							"Ten",
							"Eleven",
						}

						local phrases = {
							[0] = string.format("%s o'clock", Hours[hour + 1]),
							[1] = string.format("Quarter past %s", string.lower(Hours[hour + 1])),
							[2] = string.format("Half past %s", string.lower(Hours[hour + 1])),
							[3] = string.format("Quarter to %s", string.lower(Hours[hour + 2])),
							[4] = string.format("%s o'clock", Hours[hour + 2]),
						}

						local minute_index = math.floor((minute + 7.5) / 15) -- Round to nearest quarter
						return phrases[minute_index] -- quarter past, half past, quarter to
					end,
					"data",
				},
			},
			extensions = { "quickfix", "fugitive", "nvim-tree" },
		})
	end,
}
