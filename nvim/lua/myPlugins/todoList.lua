--🔧 Code Quality & Consistency
-- Use local state where possible instead of _G. Consider using a module table like M = {} and return it at the end.
-- Group functions better: UI, utils, ignore, cache, etc.
-- Cache repeated calls to vim.fn or vim.api if used often inside loops (vim.fn.fnamemodify, vim.fn.readfile, etc.).
-- Always check edge cases like file == nil or line:find(...) == nil.
-- ⚡ Performance
-- vim.fn.readfile() reads the entire file into memory—on big files this might be slow. Consider using io.lines.
-- Use vim.loop.fs_stat() once per file instead of twice (you use it in get_todos and then again in write_file logic). In get_todos, cache the result of vim.fn.filereadable(file) to avoid calling it multiple times.
-- 🧠 UX/Features
-- Add a filter by TODO: category, like TODO:URGENT, TODO:FIXME, etc.
-- Add highlighting to TODO lines when opened (via extmarks or signs).
-- Let users define custom keywords or regexes to scan for (like HACK, BUG, NOTE).
-- Integrate with LSP diagnostics if needed (just for synergy).
-- 🧪 Testing & Safety
-- Wrap dangerous operations (io.open, file I/O) in pcall.
-- Log errors to a log file in cache dir (optional: toggle debug mode).
-- Add a setup function where users can override default paths and options.
-- Provide a way to re-scan a single file (force update in case cache is stale).
-- ✨ Aesthetic
-- Use Lua string interpolation (string.format) consistently.
-- For floating UIs, consider using plenary.popup or a layout helper if the UI grows.
-- You could optionally use telescope.nvim for selecting todos with fuzzy search.

-- TODO: Make ripgrep async (look at projectManager.lua debug.lua)

local ignore_list_file_path = vim.fn.stdpath("config") .. "/.todoList.lua"
local ignore_pattern_file_path = vim.fn.stdpath("config") .. "/.todoListPattern.lua"
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
_G.todo_list_use_ripgrep = true
_G.todo_list_ignore_list = load_file(ignore_list_file_path)
_G.todo_list_ignore_pattern = load_file(ignore_pattern_file_path)
_G.todo_list_cache = load_file(todo_list_cache)

local function cache_clear()
	vim.print("Clearing cache")
	_G.todo_list_cache = {}
	write_file(todo_list_cache, _G.todo_list_cache)
end

local function cache_view()
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
	if todos == nil or type(todos) ~= "table" then
		vim.print("Was not able to display the todos")
		return
	end
	if #todos == 0 then
		vim.print("No todos found")
		return
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

local function filter_ignore_pattern(files)
	local filtered_files = {}
	local filter_file = false
	for _, file in ipairs(files) do
		filter_file = false
		for _, pattern in ipairs(_G.todo_list_ignore_pattern) do
			if file:find(pattern) then
				filter_file = true
			end
		end
		if not filter_file then
			table.insert(filtered_files, file)
		end
	end
	return filtered_files
end

local function get_todos_no_ripgrep_small(file)
	local todo_start, todo_end, todo
	local file_todos = {}
	local lines = vim.fn.readfile(file)
	for lnum, line in ipairs(lines) do
		todo_start, todo_end = line:find("TODO:")
		if todo_end then
			todo = {
				file = file,
				name = vim.fn.fnamemodify(file, ":t"), -- Stores the name of the file that will be displayed in the UI
				text = string.sub(line, todo_end + 1, todo_end + 1 + 128),
				lnum = lnum,
				col = todo_start,
			}
			table.insert(file_todos, todo)
		end
	end
	return file_todos
end

local function get_todos_no_ripgrep_large(file)
	local file_todos = {}
	local fh, err = io.open(file, "r")
	if not fh then
		error("Could not open file: " .. err)
	end
	for lnum = 1, math.huge do
		local line = fh:read("*l")
		if not line then
			break
		end
		local todo_start, todo_end = line:find("TODO:")
		if todo_end then
			local snippet = line:sub(todo_end + 1, todo_end + 128)
			local todo = {
				file = file,
				name = vim.fn.fnamemodify(file, ":t"),
				text = snippet,
				lnum = lnum,
				col = todo_start,
			}
			table.insert(file_todos, todo)
		end
	end
	fh:close()
	return file_todos
end

local function get_todos_no_ripgrep(files)
	local todos, file_todos, file_cache
	local write_cache = false
	for _, file in ipairs(files) do
		file_todos = {}

		-- Load cache for file
		file_cache = _G.todo_list_cache[file]
		if file_cache and file_cache.mtime > vim.loop.fs_stat(file).mtime.sec then
			file_todos = file_cache.todos
			goto insert_todos
		end

		-- Find todos in files
		if vim.fn.getfsize(file) < 1024 * 1024 then
			file_todos = get_todos_no_ripgrep_small(file)
		else
			file_todos = get_todos_no_ripgrep_large(file)
		end

		-- Update cache
		if file_todos then
			_G.todo_list_cache[file] = {
				mtime = os.time(),
				todos = file_todos,
			}
			write_cache = true
		end

		::insert_todos::
		for _, todo in ipairs(file_todos) do
			table.insert(todos, todo)
		end
	end
	return todos, write_cache
end

local function get_todos_ripgrep(files)
	local file_todos, file_cache
	local todos, files_left = {}, {}
	local write_cache = false

	-- Load from cache
	for _, file in ipairs(files) do
		file_todos = {}

		-- Load cache for file
		file_cache = _G.todo_list_cache[file]
		if file_cache and file_cache.mtime > vim.loop.fs_stat(file).mtime.sec then
			file_todos = file_cache.todos
		else
			table.insert(files_left, file)
		end

		for _, todo in ipairs(file_todos) do
			table.insert(todos, todo)
		end
	end

	if #files_left == 0 then
		return todos, false
	end

	-- build the ripgrep command
	local cmd_template = { "rg", "--vimgrep", "TODO:" }
	local chunks = {}
	local count = 1
	local chunk_size = 100

	-- build chunks of files
	for i, f in ipairs(files_left) do
		if not chunks[count] then
			chunks[count] = {}
		end
		if i > chunk_size * count then
			count = count + 1
			chunks[count] = {}
		end
		table.insert(chunks[count], f)
	end

	-- run ripgrep on each chunk
	local output = {}

	for i = 1, count do
		-- prepare the command for this chunk
		local cmd = vim.deepcopy(cmd_template)
		for _, f in ipairs(chunks[i]) do
			table.insert(cmd, f)
		end

		-- execute ripgrep
		local cmd_output = vim.fn.systemlist(cmd)

		-- append results
		for _, line in ipairs(cmd_output) do
			table.insert(output, line)
		end
	end

	local file_name = nil
	file_todos = {}

	-- helper to flush current file todos
	local function flush()
		if file_name and #file_todos > 0 then
			_G.todo_list_cache[file_name] = {
				mtime = os.time(),
				todos = file_todos,
			}
			for _, todo in ipairs(file_todos) do
				table.insert(todos, todo)
			end
			write_cache = true
		end
	end

	for _, entry in ipairs(output) do
		-- parse each line
		local path, lnum, col, text = entry:match("^(.-):(%d+):(%d+):(.*)$")
		if path then
			if path ~= file_name then
				flush() -- flush previous file
				file_name = path
				file_todos = {}
			end

			local _, todo_end = text:find("TODO:")
			local snippet = text:sub((todo_end or 4) + 1, (todo_end or 4) + 128)

			table.insert(file_todos, {
				file = path,
				name = vim.fn.fnamemodify(path, ":t"),
				text = snippet,
				lnum = tonumber(lnum),
				col = tonumber(col),
			})
		end
	end

	flush() -- final flush after loop

	return todos, write_cache
end

local function get_todos_ripgrep_async(files)
	-- TODO: Fix for when there are many files, maybe chunk up the files.
	-- TODO: Make the chunks run in parallel.
	local file_todos, file_cache
	local todos, files_left = {}, {}
	local write_cache = false
	local uv = vim.uv
	local stdin_1 = uv.new_pipe()
	local stdout = uv.new_pipe()

	-- Load from cache
	for _, file in ipairs(files) do
		file_todos = {}

		-- Load cache for file
		file_cache = _G.todo_list_cache[file]
		if file_cache and file_cache.mtime > vim.loop.fs_stat(file).mtime.sec then
			file_todos = file_cache.todos
		else
			table.insert(files_left, file)
		end

		for _, todo in ipairs(file_todos) do
			table.insert(todos, todo)
		end
	end

	if #files_left == 0 then
		return todos, false
	end

	local args = { "--vimgrep", "TODO:" }
	for _, file in ipairs(files_left) do
		table.insert(args, file)
	end

	local handle_1, pid = uv.spawn("rg", {
		stdio = { stdin_1, stdout, stderr },
		args = args,
	}, function(code, signal)
		-- TODO: Maybe the code from the vim.schedule bellow should be moved to the callback function
	end)

	local result = ""

	uv.read_start(stdout, function(err, data)
		assert(not err, err)
		if data then
			result = result .. data
		else
			-- EOF
			vim.schedule(function()
				-- vim.print("result", result)
				local lines = {}
				for line in string.gmatch(result, "([^\n]+)") do
					if line:find("TODO:") then
						table.insert(lines, line)
					end
				end
				vim.print("Lines:", lines)
				vim.print("Lines:", #lines)
				local file_name = nil
				file_todos = {}

				-- helper to flush current file todos
				local function flush()
					if file_name and #file_todos > 0 then
						_G.todo_list_cache[file_name] = {
							mtime = os.time(),
							todos = file_todos,
						}
						for _, todo in ipairs(file_todos) do
							table.insert(todos, todo)
						end
						write_cache = true
					end
				end

				for _, entry in ipairs(lines) do
					-- parse each line
					local path, lnum, col, text = entry:match("^(.-):(%d+):(%d+):(.*)$")
					if path then
						if path ~= file_name then
							flush() -- flush previous file
							file_name = path
							file_todos = {}
						end

						local _, todo_end = text:find("TODO:")
						local snippet = text:sub((todo_end or 4) + 1, (todo_end or 4) + 128)

						table.insert(file_todos, {
							file = path,
							name = vim.fn.fnamemodify(path, ":t"),
							text = snippet,
							lnum = tonumber(lnum),
							col = tonumber(col),
						})
					end
				end

				flush() -- final flush after loop
				display_todos(todos)
			end)
		end
	end)

	uv.shutdown(stdin_1, function()
		-- vim.print("stdin shutdown", stdin)
		uv.close(handle_1, function()
			-- vim.print("process closed", handle, pid)
		end)
	end)
	return todos, write_cache
end

local function f_toggle_ripgrep()
	_G.todo_list_use_ripgrep = not _G.todo_list_use_ripgrep
	print("Use ripgrep is now", _G.todo_list_use_ripgrep)
end

local function get_todos(files)
	local todos, write_cache
	if _G.todo_list_use_ripgrep then
		todos, write_cache = get_todos_ripgrep(files)
	else
		todos, write_cache = get_todos_no_ripgrep(files)
	end
	if write_cache then
		write_file(todo_list_cache, _G.todo_list_cache)
	end
	return todos
end

local function get_todos_async(files)
	local todos, write_cache
	if _G.todo_list_use_ripgrep then
		todos, write_cache = get_todos_ripgrep_async(files)
	else
		todos, write_cache = get_todos_no_ripgrep_async(files)
	end
	if write_cache then
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
	files = filter_ignore_pattern(files)
	files = filter_ignore_list(files)
	local todos = get_todos(files)
	display_todos(todos)
end

local function f_folder_async(path)
	local uv = vim.uv
	local stdin = uv.new_pipe()
	local stdout = uv.new_pipe()

	local output = ""

	local handle, pid = uv.spawn("find", {
		stdio = { stdin, stdout, stderr },
		args = { path, "-type", "f" },
	}, function(code, signal) end)

	uv.read_start(stdout, function(err, data)
		assert(not err, err)
		if data then
			output = output .. data
		else
			vim.schedule(function()
				local files = {}
				for file in output:gmatch("([^\n]+)") do
					table.insert(files, file)
				end
				vim.print("Before filter:", #files)
				files = filter_ignore_pattern(files)
				files = filter_ignore_list(files)
				vim.print("After filter:", #files)
				local todos = get_todos_async(files)
			end)
		end
	end)

	uv.shutdown(stdin, function()
		-- vim.print("stdin shutdown", stdin)
		uv.close(handle, function()
			-- vim.print("process closed", handle, pid)
		end)
	end)
end

vim.keymap.set("n", "<Leader>tf", function()
	f_folder_async(vim.fn.getcwd())
end, { desc = "Find files in folder asynchronously" })

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
	git_files = filter_ignore_pattern(git_files)
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

local function f_next_todo()
	local todos = get_todos({ vim.api.nvim_buf_get_name(0) })
	local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
	if #todos == 0 then
		vim.print("No todos found")
		return
	end
	local jumped = false
	for _, todo in ipairs(todos) do
		if todo.lnum > cursor_line then
			vim.api.nvim_win_set_cursor(0, { todo.lnum, todo.col })
			jumped = true
			break
		end
	end
	if not jumped then
		vim.api.nvim_win_set_cursor(0, { todos[1].lnum, todos[1].col })
	end
end

local function f_prev_todo()
	local todos = get_todos({ vim.api.nvim_buf_get_name(0) })
	if #todos == 0 then
		vim.print("No todos found")
		return
	end
	local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
	local move_to = { todos[#todos].lnum, todos[#todos].col } -- Line num and col
	local jumped = false
	for _, todo in ipairs(todos) do
		if todo.lnum < cursor_line then
			move_to = { todo.lnum, todo.col }
		else
			vim.api.nvim_win_set_cursor(0, move_to)
			jumped = true
			break
		end
	end
	if not jumped then
		vim.api.nvim_win_set_cursor(0, move_to)
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

local function ignore_pattern_view()
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
		vim.cmd("edit " .. vim.fn.fnameescape(ignore_pattern_file_path))
	end)

	local buf = vim.api.nvim_win_get_buf(win)

	vim.api.nvim_create_autocmd("WinClosed", {
		pattern = tostring(win),
		callback = function()
			_G.todo_list_ignore_pattern = load_file(ignore_pattern_file_path)
		end,
	})

	vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>w|bd<CR>", { noremap = true, silent = true })
end

vim.api.nvim_create_user_command("TodoListToggleRipGrep", f_toggle_ripgrep, {})

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
keymap("n", "<Leader>t", "<Nop>", { desc = "Todo list" })
keymap("n", "<Leader>tt", f_current_buffer, { desc = "Current buffer" })
keymap("n", "<Leader>tb", f_current_buffers, { desc = "Open buffers" })
keymap("n", "<Leader>tc", function()
	local cwd = vim.fn.getcwd()
	f_folder(cwd)
end, { desc = "Cwd" })
keymap("n", "<Leader>tg", f_git, { desc = "Current git repositorie" })

keymap("n", "<Leader>tn", f_next_todo, { desc = "Next TODO in buffer" })
keymap("n", "<Leader>tN", f_prev_todo, { desc = "Previous TODO in buffer" })

keymap("n", "<Leader>ti", ignore_list_add, { desc = "Add to ignore list" })
keymap("n", "<Leader>tr", ignore_list_remove, { desc = "Remove from ignore list" })
keymap("n", "<Leader>tv", ignore_list_view, { desc = "View ignore list" })
keymap("n", "<Leader>tp", ignore_pattern_view, { desc = "View ignore pattern" })

keymap("n", "<Leader>tC", cache_clear, { desc = "Clear cache" })
keymap("n", "<Leader>tV", cache_view, { desc = "View cache" })
