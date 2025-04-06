-- TODO: Add caching, for faster startup
local function display_todos(todos)
	vim.ui.select(todos, {
		prompt = "Select a TODO to open:",
		format_item = function(item)
			return string.format("%d:%s", item.lnum, item.text)
		end,
	}, function(selected)
		if selected then
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
	display_todos(todos)
end

-- Find TODOs in all buffers
local function find_todos_buffers()
	local todos = {}
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		for lnum = 1, vim.api.nvim_buf_line_count(bufnr) do
			local line = vim.api.nvim_buf_get_lines(bufnr, lnum, lnum + 1, false)[1]
			if line:find("TODO:") then
				table.insert(todos, {
					bufnr = bufnr,
					lnum = lnum,
					col = line:find("TODO:"),
					text = line,
				})
			end
		end
	end
	display_todos(todos)
end

local function find_todos_cwd()
	local cwd = vim.fn.getcwd()
	local todos = {}
	for _, file in ipairs(vim.fn.readdir(cwd)) do
		local path = cwd .. "/" .. file
		if vim.fn.getftype(path) == "file" then
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
		end
	end
	display_todos(todos)
end

local function find_todos_git()
	local todos = {}

	-- Get current file and verify it's in git
	local current_file = vim.fn.expand("%:p")
	local is_tracked = vim.fn.system("git ls-files --error-unmatch " .. vim.fn.shellescape(current_file))
	if vim.v.shell_error ~= 0 then
		print("File not in git repository")
		return
	end

	-- Find git root
	local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]

	-- Get list of tracked files
	local files = vim.fn.systemlist("git ls-files", git_root)

	for _, rel_path in ipairs(files) do
		local full_path = git_root .. "/" .. rel_path
		local lines = vim.fn.readfile(full_path)

		for lnum, line in ipairs(lines) do
			local col = line:find("TODO:")
			if col then
				table.insert(todos, {
					bufnr = vim.fn.bufnr(full_path, true), -- load buffer if needed
					lnum = lnum,
					col = col,
					text = line,
					file = full_path,
				})
			end
		end
	end
	display_todos(todos)
end

local function find_todos_home() end
local function find_todos_system() end

vim.api.nvim_create_user_command("TodoList", find_todos, {})
vim.api.nvim_create_user_command("TodoListBuffers", find_todos_buffers, {})
vim.api.nvim_create_user_command("TodoListCWD", find_todos_cwd, {})
vim.api.nvim_create_user_command("TodoListGit", find_todos_git, {})
vim.api.nvim_create_user_command("TodoListHome", find_todos_home, {})
vim.api.nvim_create_user_command("TodoListSystem", find_todos_system, {})

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
keymap("n", "<Leader>tt", find_todos, opts)
keymap("n", "<Leader>tb", find_todos_buffers, opts)
keymap("n", "<Leader>tc", find_todos_cwd, opts)
keymap("n", "<Leader>tg", find_todos_git, opts)
keymap("n", "<Leader>th", find_todos_home, opts)
keymap("n", "<Leader>ts", find_todos_system, opts)
