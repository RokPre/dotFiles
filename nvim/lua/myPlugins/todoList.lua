-- TODO: Add caching, for faster startup
local ignore_list_file_path = vim.fn.stdpath("config") .. "/.todoList.lua"
local ok, ignore_list = pcall(dofile, ignore_list_file_path)
if ok and type(ignore_list) == "table" then
	_G.todo_list_ignore_list = ignore_list
else
	_G.todo_list_ignore_list = {}
end

local function contains(tbl, val)
	for _, v in ipairs(tbl) do
		if v == val then
			return true
		end
	end
	return false
end

local function display_todos(todos, opts)
	-- vim.print("Todos: ", todos)
	vim.ui.select(todos, {
		prompt = "Select a TODO to open:",
		format_item = function(item)
			local file_name
			local file_path
			-- Display the file name or line number
			if opts.file_name then
				if item.file then
					-- Display file name
					file_path = item.file
				else
					-- Display buffer name
					file_path = vim.api.nvim_buf_get_name(item.bufnr)
				end
				file_name = vim.fn.fnamemodify(file_path, ":t")
			else
				file_name = item.lnum
			end

			return string.format("%s:%s", file_name, item.text)
		end,
	}, function(selected)
		if selected then
			if selected.file then
				vim.cmd("e " .. selected.file)
			else
				vim.api.nvim_set_current_buf(selected.bufnr)
			end
			vim.api.nvim_win_set_cursor(0, { selected.lnum, selected.col - 1 })
			vim.cmd("normal! zz") -- optional: center the cursor
		end
	end)
end

-- Find TODOs in the current buffer
local function find_todos()
	local todos = {}
	for lnum = 1, vim.fn.line("$") do
		local line = vim.fn.getline(lnum)
		if line:find("TODO:") then
			table.insert(todos, {
				bufnr = 0,
				lnum = lnum,
				col = line:find("TODO:"),
				text = line,
			})
		end
	end
	local opts = { file_name = false }
	display_todos(todos, opts)
end

-- Find TODOs in all buffers
local function find_todos_buffers()
	local todos = {}

	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		-- Only process loaded and listed buffers
		if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_get_option(bufnr, "buflisted") then
			local line_count = vim.api.nvim_buf_line_count(bufnr)

			for lnum = 1, line_count do
				local lines = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)
				local line = lines[1]
				if line and line:find("TODO:") then
					table.insert(todos, {
						bufnr = bufnr,
						lnum = lnum,
						col = line:find("TODO:"),
						text = line,
					})
				end
			end
		end
	end

	local opts = { file_name = true }
	display_todos(todos, opts)
end

local function find_todos_path(path)
	local todos = {}
	-- Get all files in cwd with infinite depth
	local files = vim.fn.glob(path .. "/**/*", true, true)

	for _, file in ipairs(files) do
		if contains(_G.todo_list_ignore_list, file) then
			goto continue
		end
		-- Check if the file is a regular file
		if vim.fn.getftype(file) == "file" then
			-- print(file)
			-- Open the file and check for TODO:
			local lines = vim.fn.readfile(file)
			for lnum, line in ipairs(lines) do
				if line:find("TODO:") then
					table.insert(todos, {
						lnum = lnum, -- line number where TODO: appears
						col = line:find("TODO:"), -- column where TODO: starts
						text = line, -- the actual line with TODO:
						file = file, -- store the actual file path
					})
				end
			end
		end
		::continue::
	end

	-- Display todos
	local opts = { file_name = true }
	display_todos(todos, opts)
end

local function find_todos_git()
	-- Get the current file path
	local file_dir = vim.fn.expand("%:p:h") -- Get the directory of the file
	-- print(file_dir)

	-- Check if the file is inside a git repo by running git rev-parse
	local cmd = "git -C " .. file_dir .. " rev-parse --show-toplevel 2>/dev/null"
	local in_repo = vim.fn.system(cmd)
	-- print(in_repo)

	if in_repo == "" then
		print("File is not in a git repository")
		return
	end

	-- Trim any extra whitespace from the result
	local git_root = vim.fn.trim(in_repo)

	local todos = {}
	cmd = "git ls-files " .. git_root
	cmd = "git -C " .. git_root .. " ls-files"
	local files = vim.fn.system(cmd)
	files = vim.fn.split(files, "\n")
	-- vim.print("files: ", files)

	for _, file in ipairs(files) do
		if contains(_G.todo_list_ignore_list, file) then
			goto gitcontinue
		end
		file = git_root .. "/" .. file
		if vim.fn.filereadable(file) == 1 then
			-- Open the file and check for TODO:
			local lines = vim.fn.readfile(file)
			for lnum, line in ipairs(lines) do
				if line:find("TODO:") then
					table.insert(todos, {
						lnum = lnum,
						col = line:find("TODO:"),
						text = line,
						file = file,
					})
				end
			end
		end
		::gitcontinue::
	end

	-- Display todos
	local opts = { file_name = true }
	display_todos(todos, opts)
end

local function update_ignore_file()
	local f = io.open(ignore_list_file_path, "w")
	if f then
		-- Write the table so that it can be loaded as a Lua module if needed
		f:write("return " .. vim.inspect(_G.project_manager_ignore_list))
		f:close()
	else
		print("Error opening file: " .. ignore_list_file_path)
	end
end

local function add_to_ignore_list()
	local current_buffer_path = vim.fn.expand("%:p")
	if not contains(_G.todo_list_ignore_list, current_buffer_path) then
		table.insert(_G.todo_list_ignore_list, current_buffer_path)
		print("Added: " .. current_buffer_path)
		update_ignore_file()
	end
end

local function remove_from_ignore_list()
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
		update_ignore_file()
	else
		print("Repository not found in ignore list: " .. current_buffer_path)
	end
end

local function view_ignore_list()
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

vim.api.nvim_create_user_command("TodoList", find_todos, {})
vim.api.nvim_create_user_command("TodoListBuffers", find_todos_buffers, {})
vim.api.nvim_create_user_command("TodoListGit", find_todos_git, {})
vim.api.nvim_create_user_command("TodoListCWD", "lua: find_todos_path(vim.fn.getcwd())", {})
vim.api.nvim_create_user_command("TodoListHome", "lua: find_todos_path(vim.fn.getenv('HOME'))", {})
vim.api.nvim_create_user_command("TodoListAddToIgnoreList", add_to_ignore_list, {})
vim.api.nvim_create_user_command("TodoListRemoveFromIgnoreList", remove_from_ignore_list, {})
vim.api.nvim_create_user_command("TodoListViewIgnoreList", remove_from_ignore_list, {})

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
keymap("n", "<Leader>tt", find_todos, opts)
keymap("n", "<Leader>tb", find_todos_buffers, opts)
keymap("n", "<Leader>tg", find_todos_git, opts)
keymap("n", "<Leader>tc", "lua: find_todos_path(vim.fn.getcwd())", opts)
keymap("n", "<Leader>tc", "lua: find_todos_path(vim.fn.getenv('HOME'))", opts)
keymap("n", "<Leader>ti", add_to_ignore_list, opts)
keymap("n", "<Leader>tr", remove_from_ignore_list, opts)
keymap("n", "<Leader>tv", view_ignore_list, opts)
