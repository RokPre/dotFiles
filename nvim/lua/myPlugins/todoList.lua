-- TODO: Add caching, for faster startup
-- TODO: If there are no todos, do not display the ui.
-- TODO: Sort the todos by the date of the last eidt date of the file, that the todo is in.
-- TODO: make the cahce location stdpath("cache")
-- TODO: Fix ignore list
local ignore_list_file_path = vim.fn.stdpath("config") .. "/.todoList.lua"
local ignore_list_cache = vim.fn.stdpath("cache") .. "/.todoList.lua"

-- Load the ignore list file
local iok, ignore_list = pcall(dofile, ignore_list_file_path)
if iok and type(ignore_list) == "table" then
	_G.todo_list_ignore_list = ignore_list
else
	_G.todo_list_ignore_list = {}
	print("Didnt find an ignore list file")
end

-- Load the cache file
local cok, cache = pcall(dofile, ignore_list_cache)
if cok and type(cache) == "table" then
	_G.todo_list_cache = cache
else
	_G.todo_list_cache = {}
	print("Didn't find cache file")
end

local function contains(tbl, val)
	for _, v in ipairs(tbl) do
		if v == val then
			return true
		end
	end
	return false
end

local function display_todos(todos)
	-- opts.display_file_name, if true, will display the file name, or the buffer name, depending on what is availbale. (When dissplaying todos most of the time)
	--                 if false, will display the line number of the TODO. (Used for showing todos in current buffer)
	if #todos == 0 then
		print("No todos found")
		return 1
	end

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

local function find_todos_buffers(buffers, opts)
	-- Desc: Finds all todos in a list of buffers
	-- Args: buffers (table): List of buffer numbers
	-- Output: todos (table): List of todos
	-- TODO: Input verification
	local todos = {}
	local ignored_todos = {}

	if type(buffers) ~= "table" then
		buffers = { buffers }
	end

	for _, bufnr in ipairs(buffers) do
		local buffer_name = vim.api.nvim_buf_get_name(bufnr)
		if contains(_G.todo_list_ignore_list, buffer_name) and opts.use_ignore_list then
			table.insert(ignored_todos, buffer_name)
			goto ignorebuffer
		end

		local line_count = vim.api.nvim_buf_line_count(bufnr)
		for lnum = 1, line_count do
			local lines = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)
			local line = lines[1]
			if line and line:find("TODO:") then
				table.insert(todos, {
					name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t"),
					file = vim.api.nvim_buf_get_name(bufnr),
					lnum = lnum,
					col = line:find("TODO:"),
					text = line,
				})
			end
		end
		::ignorebuffer::
	end
	if display_todos(todos) == 1 then
		if #ignored_todos ~= 0 then
			vim.print("Some buffers where ignored")
		end
	end
end

local function find_todos_file(file)
	vim.print(file)
	local todos = {}
	-- Check if the file is a regular file
	if vim.fn.getftype(file) == "file" then
		-- print(file)
		-- Open the file and check for TODO:
		local lines = vim.fn.readfile(file)
		for lnum, line in ipairs(lines) do
			if line:find("TODO:") then
				table.insert(todos, {
					name = vim.fn.fnamemodify(file, ":t"), -- store the actual file path
					file = file,
					lnum = lnum, -- line number where TODO: appears
					col = line:find("TODO:"), -- column where TODO: starts
					text = line, -- the actual line with TODO:
				})
			end
		end
	end
	return todos
end

local function find_todos_path(path)
	local todos = {}
	local ignored_todos = {}
	local cmd = "find " .. vim.fn.shellescape(path) .. " -type f"
	local files = vim.fn.systemlist(cmd)
	for _, file in ipairs(files) do
		if not contains(_G.todo_list_ignore_list, file) then
			todos = vim.fn.extend(todos, find_todos_file(file))
			table.insert(ignored_todos, file)
		end
	end
	if display_todos(todos) == 1 then
		if #ignored_todos ~= 0 then
			vim.print("Some files where ignored")
		end
	end
end

local function find_todos_git(path)
	-- Desc: Shows the toods for a git repository based on the path of provided
	-- Args: path (string): Path to a file inside a git repository
	-- Output: todos (table): List of todos
	-- TODO: Input verification
	local todos = {}
	local cmd = "git -C '" .. path .. "' rev-parse --show-toplevel 2>/dev/null"
	local in_repo = vim.fn.system(cmd)

	if in_repo == "" then
		print(in_repo)
		print("File is not in a git repository")
		return
	end

	local git_root = vim.fn.trim(in_repo)
	print("git_root:", git_root)

	cmd = "git -C " .. git_root .. " ls-files"
	local files = vim.fn.system(cmd)
	files = vim.fn.split(files, "\n")

	for _, file in ipairs(files) do
		if not contains(_G.todo_list_ignore_list, file) then
			todos = vim.fn.extend(todos, find_todos_file(git_root .. "/" .. file))
		end
	end
	display_todos(todos)
end

-----------------
-- Ignore list --
-----------------
local function ignore_list_update()
	local f = io.open(ignore_list_file_path, "w")
	if f then
		-- Write the table so that it can be loaded as a Lua module if needed
		f:write("return " .. vim.inspect(_G.todo_list_ignore_list))
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
		print("Removed repository from ignore list: " .. current_buffer_path)
		ignore_list_update()
	else
		print("Repository not found in ignore list: " .. current_buffer_path)
	end
end

local function ignore_list_view()
	local f = io.open(ignore_list_file_path, "r")
	if not f then
		print("Error opening file: " .. ignore_list_file_path)
		return
	end

	local content = f:read("*all")
	f:close()
	local lines = vim.split(content, "\n")

	-- Create a new normal buffer and assign the file path
	local buf = vim.api.nvim_create_buf(true, false)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_buf_set_name(buf, ignore_list_file_path)

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

vim.api.nvim_create_user_command("TodoList", function()
	find_todos_buffers(vim.api.nvim_get_current_buf(), { ignore_list = false })
end, {})
vim.api.nvim_create_user_command("TodoListBuffers", function()
	find_todos_buffers(vim.api.nvim_list_bufs(), { ignore_list = true })
end, {})
vim.api.nvim_create_user_command("TodoListGit", function()
	find_todos_git(vim.fn.expand("%:p:h"))
end, {})
vim.api.nvim_create_user_command("TodoListCWD", function()
	find_todos_path(vim.fn.getcwd())
end, {})
vim.api.nvim_create_user_command("TodoListHome", function()
	find_todos_path(vim.fn.getenv("HOME"))
end, {})

vim.api.nvim_create_user_command("TodoListAddToIgnoreList", ignore_list_add, {})
vim.api.nvim_create_user_command("TodoListRemoveFromIgnoreList", ignore_list_remove, {})
vim.api.nvim_create_user_command("TodoListViewIgnoreList", ignore_list_remove, {})

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
keymap("n", "<Leader>tt", function()
	find_todos_buffers(vim.api.nvim_get_current_buf(), { use_ignore_list = false })
end, opts)
keymap("n", "<Leader>tb", function()
	find_todos_buffers(vim.api.nvim_list_bufs(), { use_ignore_list = true })
end, opts)
keymap("n", "<Leader>tg", function()
	find_todos_git(vim.fn.expand("%:p:h"))
end, opts)
keymap("n", "<Leader>tc", function()
	find_todos_path(vim.fn.getcwd())
end, opts)
keymap("n", "<Leader>th", function()
	find_todos_path(vim.fn.getenv("HOME"))
end, opts)

keymap("n", "<Leader>ti", ignore_list_add, opts)
keymap("n", "<Leader>tr", ignore_list_remove, opts)
keymap("n", "<Leader>tv", ignore_list_view, opts)
