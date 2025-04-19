-- TODO: Add ignore pattern
-- TODO: Add support for FIXME:
local ignore_list_file_path = vim.fn.stdpath("config") .. "/.todoList.lua"
local todo_list_cache = vim.fn.stdpath("cache") .. "/.todoList.lua"

local function load_file(file_path)
	local data = {}
	local ok, from_file = pcall(dofile, file_path)
	if ok and type(from_file) == "table" then
		data = from_file
	end
	return data
end

local function write_file(file, variable)
	local f = io.open(file, "w")
	if f then
		f:write("return " .. vim.inspect(variable))
		f:close()
	else
		vim.print("Error opening file: " .. file)
	end
end

_G.todo_list_ignore_list = load_file(ignore_list_file_path)
_G.todo_list_cache = load_file(todo_list_cache)

local function cache_clear()
	vim.print("Clearing cache")
	_G.todo_list_cache = {}
	write_file(todo_list_cache, _G.todo_list_cache)
end

local function cache_view()
	-- TODO: view_cache. Load the cahce file not the variable.
	-- TODO: update the cache varibale after saving the cache file.
	local cache_dump = vim.inspect(_G.todo_list_cache)
	local lines = vim.split(cache_dump, "\n")

	-- Create a new scratch buffer
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_buf_set_name(buf, "TODO Cache")

	-- Set key mapping to close the window on pressing q
	vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>bd!<CR>", { noremap = true, silent = true })

	-- Calculate floating window size and position
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	-- Open the floating window
	vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	})
end

local function display_todos(todos)
	-- TODO: Input validation
	vim.ui.select(todos, {
		prompt = "Select a TODO to open:",
		format_item = function(todo)
			local display_string = string.format("%s:%s", todo.name, todo.text)
			return display_string
		end,
	}, function(selected)
		if selected then
			vim.cmd("e " .. selected.file)
			vim.api.nvim_win_set_cursor(0, { selected.lnum, selected.col - 1 })
		end
	end)
end

local function contains(tbl, val)
	for _, v in ipairs(tbl) do
		if vim.fn.fnamemodify(v, ":p") == vim.fn.fnamemodify(val, ":p") then
			return true
		end
	end
	return false
end

local function filter_ignore_list(files)
	local filtered = {}
	for _, file in ipairs(files) do
		if not contains(_G.todo_list_ignore_list, file) then
			table.insert(filtered, file)
		end
	end
	return filtered
end

local function get_todos(files)
	local todos = {}
	local file_todos, file_cache, line_todo
	local update_cache
	for _, file in ipairs(files) do
		update_cache = false
		file_todos = {}
		file_cache = _G.todo_list_cache[file]

		if file_cache and file_cache.mtime > vim.loop.fs_stat(file).mtime.sec then
			file_todos = file_cache.todos
			for _, todo in ipairs(file_todos) do
				table.insert(todos, todo)
			end
		elseif vim.fn.filereadable(file) == 1 then
			local lines = vim.fn.readfile(file)
			for lnum, line in ipairs(lines) do
				if line:find("TODO:") then
					line_todo = {
						file = file,
						name = vim.fn.fnamemodify(file, ":t"), -- store the actual file path
						text = line,
						lnum = lnum,
						col = line:find("TODO:"), -- TODO: Only save the text after the todo up to 128 characters
					}
					table.insert(file_todos, line_todo)
					table.insert(todos, line_todo)
					update_cache = true
				end
			end
			if update_cache then
				_G.todo_list_cache[file] = {
					mtime = os.time(),
					todos = file_todos,
				}
			end
		end
	end
	if update_cache then
		write_file(todo_list_cache, _G.todo_list_cache)
	end
	return todos
end

local function f_current_buffer()
	local file_path = vim.api.nvim_buf_get_name(0)
	local files = { file_path }
	local todos = get_todos(files)
	display_todos(todos)
end

local function f_current_buffers()
	local bufsnrs = vim.api.nvim_list_bufs()
	local files = {}
	for _, bufnr in ipairs(bufsnrs) do
		if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_get_name(bufnr) ~= "" then
			table.insert(files, vim.api.nvim_buf_get_name(bufnr))
		end
	end
	local todos = get_todos(files)
	display_todos(todos)
end

local function f_folder(path)
	local cmd = "find " .. vim.fn.shellescape(path) .. " -type f"
	local files = vim.fn.systemlist(cmd)
	files = filter_ignore_list(files)
	local todos = get_todos(files)
	display_todos(todos)
end

local function f_git()
	local current_file = vim.fn.expand("%:p:h")
	local cmd = "git -C '" .. current_file .. "' rev-parse --show-toplevel 2>/dev/null"
	local in_repo = vim.fn.system(cmd)
	if in_repo == "" then
		print("File is not in a git repository")
		return
	end

	local git_root = vim.fn.trim(in_repo)
	local git_files = {}

	cmd = "git -C " .. git_root .. " ls-files"
	local files = vim.fn.system(cmd)
	files = vim.fn.split(files, "\n")
	for i, file in ipairs(files) do
		git_files[i] = git_root .. "/" .. file
	end
	git_files = filter_ignore_list(git_files)
	local todos = get_todos(git_files)
	display_todos(todos)
end

-- Ignore list
local function ignore_list_update()
	local f = io.open(ignore_list_file_path, "w")
	if f then
		-- This is just so that the file is formated nicely with proper indentation.
		f:write(
			"return{\n\t" .. vim.inspect(_G.todo_list_ignore_list):gsub("{ ", ""):gsub(", ", ",\n\t"):gsub(" }", "\n}")
		)

		f:close()
	else
		print("Error opening file: " .. ignore_list_file_path)
	end
end

local function ignore_list_add()
	local current_buffer_path = vim.fn.expand("%:p")
	if not contains(_G.todo_list_ignore_list, current_buffer_path) then
		table.insert(_G.todo_list_ignore_list, current_buffer_path)
		print("Added: " .. current_buffer_path)
		ignore_list_update()
	end
end

local function ignore_list_remove()
	local current_buffer_path = vim.fn.expand("%:p")
	local found = false
	for i, ignore_file_path in ipairs(_G.todo_list_ignore_list) do
		if ignore_file_path == current_buffer_path then
			table.remove(_G.todo_list_ignore_list, i)
			found = true
			break
		end
	end
	if found then
		print("Removed from ignore list: " .. current_buffer_path)
		ignore_list_update()
	else
		print("Did not find in igonre list: " .. current_buffer_path)
	end
end

local function ignore_list_view()
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local win = vim.api.nvim_open_win(0, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	})

	vim.api.nvim_win_call(win, function()
		vim.cmd("edit " .. vim.fn.fnameescape(ignore_list_file_path))
	end)

	local buf = vim.api.nvim_win_get_buf(win)

	vim.api.nvim_create_autocmd("WinClosed", {
		pattern = tostring(win),
		callback = function()
			_G.todo_list_ignore_list = load_file(ignore_list_file_path)
		end,
	})

	vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>w|bd<CR>", { noremap = true, silent = true })
end

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
keymap("n", "<Leader>tt", f_current_buffer, opts)
keymap("n", "<Leader>tb", f_current_buffers, opts)
keymap("n", "<Leader>tc", function()
	local cwd = vim.fn.getcwd()
	f_folder(cwd)
end, opts)
keymap("n", "<Leader>tg", f_git, opts)

keymap("n", "<Leader>ti", ignore_list_add, opts)
keymap("n", "<Leader>tr", ignore_list_remove, opts)
keymap("n", "<Leader>tv", ignore_list_view, opts)

keymap("n", "<Leader>tC", cache_clear, opts)
keymap("n", "<Leader>tV", cache_view, opts)

-- debug
keymap("n", "<Leader>td", function()
	f_folder("/home/lasim/debug/")
end, opts)
