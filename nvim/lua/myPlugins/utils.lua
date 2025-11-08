M = {}

--- Calculates the relative path from one file to another.
---
--- If the two files share a common parent folder, returns the relative path
--- from `staring_path` to `target_path`. Returns `nil` if no relation can be found.
---
--- @param staring_path string  The path from which the relative path is calculated.
--- @param target_path string   The path to which the relative path is calculated.
--- @param opts table|nil       Optional settings:
---   - root_folder (string|nil): The uppermost folder to consider when searching for a common parent.
---   - max_depth (number|nil): The maximum number of folder levels to traverse upward.
---
--- @return string|nil  The relative path from `staring_path` to `target_path`, or `nil` if no relation is found.
function M.calculate_relative_path(staring_path, target_path, opts)
	if staring_path == nil or target_path == nil then
		vim.notify("No path to calculate relative path from")
		return nil
	end

	if type(staring_path) ~= "string" or type(target_path) ~= "string" then
		vim.notify("Paths must be strings")
		return nil
	end

	if staring_path:find("[%z\r\n]") or target_path:find("[%z\r\n]") then
		vim.notify("Paths cannot contain NUL bytes")
		return nil
	end

	if staring_path:find('[:%*%?"<>|]') or target_path:find('[:%*%?"<>|]') then
		vim.notify("Paths contains invalid characters")
		return nil
	end

	if opts == nil then
		opts = {}
	end

	if opts.max_depth == nil then
		opts.max_depth = math.huge
	end

	staring_path = vim.fn.expand(staring_path)
	target_path = vim.fn.expand(target_path)

	-- Check if the root folder is the root of both the starting_path and the target_path. Else the files are not within the same root folder and return nil.
	if opts.root_folder ~= nil then
		local exp_root_folder = vim.fn.expand(opts.root_folder)
		if not (vim.startswith(staring_path, exp_root_folder) and vim.startswith(target_path, exp_root_folder)) then
			vim.notify("Paths are not within then root folder.")
			return nil
		end
	end

	local parent_folder = vim.fn.fnamemodify(vim.fn.expand(staring_path), ":p:h")
	local relative_path = ""
	local common_folder = nil

	local current_depth = 0

	while current_depth < opts.max_depth do
		current_depth = current_depth + 1

		-- Check if the target path starts with the parent folder, aka: find firs common folder.
		if vim.startswith(target_path, parent_folder) then
			common_folder = parent_folder
			break
		end

		-- If hit the root fo the file system, stop.
		if parent_folder == "/" then
			break
		end

		relative_path = relative_path .. "../"
		parent_folder = vim.fn.fnamemodify(parent_folder, ":h")
	end

	-- If no common folder was found, return nil.
	if common_folder == nil then
		return nil
	end

	-- Add the / to the common folder.
	if common_folder ~= "/" then
		common_folder = common_folder .. "/"
	end

	-- ^ to only find the first occurance. vim.pesc()
	return relative_path .. target_path:gsub("^" .. common_folder, "")
end

function M.in_git_repo(path)
	-- Use current working directory if not given
	if path == nil then
		path = vim.fn.getcwd()
	end

	-- Ensure path is a string
	if type(path) ~= "string" then
		vim.notify("Path must be a string", vim.log.levels.ERROR)
		return false
	end

	-- Expand ~ and resolve symlinks
	path = vim.fn.expand(path)

	-- Run git command and capture output
	local handle = io.popen("cd " .. vim.fn.shellescape(path) .. " && git rev-parse --is-inside-work-tree 2>/dev/null")
	local result = handle:read("*a")
	handle:close()

	-- Return true if inside work tree
	return result:match("true") ~= nil
end

function M.get_git_repo(path)
	-- ofOf path is not provided use current working directory
	path = path or vim.fn.getcwd()

	if type(path) ~= "string" then
		vim.notify("Path must be a string", vim.log.levels.ERROR)
		return nil
	end

	path = vim.fn.expand(path)

	if vim.fn.filereadable(path) == 1 then
		path = vim.fn.fnamemodify(path, ":h")
	end

	if vim.fn.isdirectory(path) == 0 then
		vim.notify("Folder does not exist: " .. path, vim.log.levels.ERROR)
		return nil
	end

	local handle = io.popen("cd " .. vim.fn.shellescape(path) .. " && git rev-parse --show-toplevel 2>/dev/null")
	local result = handle:read("*a")
	handle:close()

	result = result and result:gsub("%s+$", "") -- Trim newline/spaces

	if result == "" then
		return nil
	end

	return result
end

function M.read_table_from_file(path)
	if path == nil then
		vim.notify("No file path provided", vim.log.levels.ERROR)
		return nil
	end

	if type(path) ~= "string" then
		vim.notify("File path must be a string", vim.log.levels.ERROR)
		return nil
	end

	path = vim.fn.expand(path)

	if not vim.fn.filereadable(path) then
		vim.notify("File not found: " .. path, vim.log.levels.ERROR)
		return nil
	end

	local f = io.open(path, "r")
	if f == nil then
		vim.notify("Error opening file: " .. path, vim.log.levels.ERROR)
		return nil
	end

	local contents = f:read("*a") -- Read the entire file contents
	contents = contents:gsub("%s+$", "") -- Trim trailing whitespace/newlines
	local tbl = vim.split(contents, "\n", { plain = true })

	f:close()

	return tbl
end

function M.write_table_to_file(tbl, file_path)
	if file_path == nil then
		vim.notify("No file path provided", vim.log.levels.ERROR)
		return nil
	end

	if type(file_path) ~= "string" then
		vim.notify("File path must be a string", vim.log.levels.ERROR)
		return nil
	end

	if type(tbl) ~= "table" then
		vim.notify("Table must be a table", vim.log.levels.ERROR)
		return nil
	end

	file_path = vim.fn.expand(file_path)

	local f, err = io.open(file_path, "w")
	if not f then
		vim.notify("Error opening file for writing: " .. (err or file_path), vim.log.levels.ERROR)
		return
	end

	f:write(table.concat(tbl, "\n"))
	f:close()
end

function M.write_dict_to_file(dict, file_path)
	if file_path == nil then
		vim.notify("No file path provided", vim.log.levels.ERROR)
		return nil
	end

	if type(file_path) ~= "string" then
		vim.notify("File path must be a string", vim.log.levels.ERROR)
		return nil
	end

	file_path = vim.fn.expand(file_path)

	if type(dict) ~= "table" then
		vim.notify("Argument 'dict' must be a table", vim.log.levels.ERROR)
		return nil
	end

	local f, err = io.open(file_path, "w")
	if not f then
		vim.notify("Error opening file for writing: " .. (err or file_path), vim.log.levels.ERROR)
		return nil
	end

	f:write("return {\n")
	for key, value in pairs(dict) do
		f:write(string.format("  [%q] = %s,\n", key, vim.inspect(value)))
	end
	f:write("}\n")
	f:close()

	return true
end

function M.read_dict_from_file(file_path)
	if file_path == nil then
		vim.notify("No file path provided", vim.log.levels.ERROR)
		return nil
	end

	if type(file_path) ~= "string" then
		vim.notify("File path must be a string", vim.log.levels.ERROR)
		return nil
	end

	file_path = vim.fn.expand(file_path)

	local f = io.open(file_path, "r")
	if not f then
		vim.notify("File not found: " .. file_path, vim.log.levels.WARN)
		return nil
	end
	f:close()

	local ok, data = pcall(dofile, file_path)
	if not ok then
		vim.notify("Error reading file: " .. tostring(data), vim.log.levels.ERROR)
		return nil
	end

	if type(data) ~= "table" then
		vim.notify("File did not return a table: " .. file_path, vim.log.levels.ERROR)
		return nil
	end

	return data
end

return M
