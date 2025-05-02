-- projectManager .config/nvim/lua/myPlugins/projectManager.lua
local home_dir = os.getenv("HOME")
local ignore_list_file = vim.fn.stdpath("config") .. "/.project_manager_ignore_list.lua"
local ignore_pattern_file = vim.fn.stdpath("config") .. "/.project_manager_ignore_pattern.lua"
local sessionManager = require("myPlugins.sessionManager")
_G.project_manager_ignore_list = {}
_G.project_manager_ignore_pattern = {}

local function load_file(file_path)
	local ok, from_file = pcall(dofile, file_path)
	if ok and type(from_file) == "table" then
		return from_file
	else
		print("Error opening file: " .. file_path)
		return {}
	end
end

local function contains(tbl, val)
	for _, v in ipairs(tbl) do
		if v == val then
			return true
		end
	end
	return false
end

local function contains_ignore_pattern(val, ignore_patterns)
	for _, pattern in ipairs(ignore_patterns) do
		if val:find(pattern) then
			return true
		end
	end
	return false
end

----------
-- core --
----------
local function update_cache_async()
	local uv = vim.uv
	local stdin = uv.new_pipe()
	local stdout = uv.new_pipe()
	-- local stderr = uv.new_pipe()

	home_dir = os.getenv("HOME")
	local handle, pid = uv.spawn("find", {
		stdio = { stdin, stdout, stderr },
		args = { home_dir, "-type", "d", "-name", ".git" },
	}, function(code, signal)
		-- TODO: Maybe the code from the vim.schedule bellow should be moved to the callback function
	end)

	uv.read_start(stdout, function(err, data)
		assert(not err, err)
		if data then
			vim.schedule(function()
				local projects = {}
				for git_dir in data:gmatch("([^\n]+)") do
					git_dir = git_dir:gsub("/.git", "")
					if
						not contains(_G.project_manager_ignore_list, git_dir)
						and not contains_ignore_pattern(git_dir, _G.project_manager_ignore_pattern)
					then
						table.insert(projects, git_dir)
					end
				end
				_G.project_manager_cache = projects
				-- vim.print(_G.project_manager_cache)
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

local function show_projects()
	-- Shows the projects that are stored in the cache
	local repo_dirs = _G.project_manager_cache
	if not repo_dirs then
		vim.notify("No projects found. Please wait or use <Leader>pu to update the cache")
		return
	end
	vim.ui.select(repo_dirs, {
		prompt = "Select a Git repository to open:",
		format_item = function(item)
			-- return item:gsub(home_dir, "~")
			return vim.fn.fnamemodify(item, ":t")
		end,
	}, function(selected)
		if not selected then
			return
		end
		-- Save current session
		sessionManager.SaveSession()
		-- Close all buffers and windows
		vim.cmd("%bd!")
		vim.cmd("cd " .. selected)
		-- Open new session
		if sessionManager.LoadSession() == 1 then
			vim.cmd("e " .. selected)
		end
	end)
end

local function get_git_root()
	local current_file = vim.fn.expand("%:p")
	local current_dir = vim.fn.fnamemodify(current_file, ":h")
	local cmd = "cd " .. vim.fn.shellescape(current_dir) .. " && git rev-parse --show-toplevel 2>/dev/null"
	local git_root = vim.fn.system(cmd):gsub("\n", "")

	if vim.v.shell_error == 0 and git_root ~= "" then
		return git_root
	else
		return nil
	end
end

---------------------------
-- Ignore list functions --
---------------------------
-- Helper function to update the ignore list file with the current table
local function update_ignore_list()
	local f = io.open(ignore_list_file, "w")
	if f then
		f:write("return {\n")
		for _, item in ipairs(_G.project_manager_ignore_list) do
			f:write("  " .. string.format("%q", item) .. ",\n")
		end
		f:write("}\n")
		f:close()
	else
		print("Error opening file: " .. ignore_list_file)
	end
	update_cache_async()
end

local function add_to_ignore_list()
	local git_root = get_git_root()
	if not git_root then
		print("Not in a git repository")
		return
	end
	for _, ignored_repo in ipairs(_G.project_manager_ignore_list) do
		if ignored_repo == git_root then
			print("Repository already in ignore list: " .. git_root)
			return
		end
	end
	table.insert(_G.project_manager_ignore_list, git_root)
	print("Added repository to ignore list: " .. git_root .. "\n")
	update_ignore_list()
end

local function remove_from_ignore_list()
	local git_root = get_git_root()
	if not git_root then
		print("Not in a git repository")
		return
	end
	local found = false
	for i, ignored_repo in ipairs(_G.project_manager_ignore_list) do
		if ignored_repo == git_root then
			table.remove(_G.project_manager_ignore_list, i)
			found = true
			break
		end
	end
	if found then
		print("Removed repository from ignore list: " .. git_root)
		update_ignore_list()
	else
		print("Repository not found in ignore list: " .. git_root)
	end
end

local function view_ignores(file_path)
	-- Calculate floating window size and position
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	-- Open the floating window
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
		vim.cmd("edit " .. vim.fn.fnameescape(file_path))
	end)

	local buf = vim.api.nvim_win_get_buf(win)

	-- Set key mapping to close the window on pressing q
	vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>w!|bd!<CR>", { noremap = true, silent = true })

	vim.api.nvim_create_augroup("ViewIgnores", { clear = true })
	vim.api.nvim_create_autocmd("WinClosed", {
		group = "ViewIgnores",
		callback = function()
			if file_path == ignore_list_file then
				_G.project_manager_ignore_pattern = load_file(file_path)
			elseif file_path == ignore_pattern_file then
				_G.project_manager_ignore_list = load_file(file_path)
			end
		end,
	})
end

------------
-- others --
------------
local function open_readme()
	local current_file = vim.fn.expand("%:p")
	local current_dir = vim.fn.fnamemodify(current_file, ":h")

	local git_root_cmd = "cd " .. vim.fn.shellescape(current_dir) .. " && git rev-parse --show-toplevel 2>/dev/null"
	local git_root = vim.fn.system(git_root_cmd):gsub("\n", "")

	if git_root == "" then
		print("Not inside a git repo.")
		return
	end

	local find_cmd = "cd " .. vim.fn.shellescape(git_root) .. " && find . -name README.md"
	local output = vim.fn.system(find_cmd)

	-- split lines into a table
	local files = {}
	for line in output:gmatch("[^\r\n]+") do
		local normalized_path = vim.fn.fnamemodify(git_root .. "/" .. line:gsub("^%./", ""), ":p")
		table.insert(files, normalized_path)
	end

	table.sort(files, function(a, b)
		return #a < #b
	end)

	if #files == 0 then
		print("No README.md file found")
	elseif #files == 1 then
		vim.cmd("e " .. vim.fn.fnameescape(files[1]))
	else
		if vim.ui.select then
			vim.ui.select(files, {
				prompt = "Select a README.md file to open:",
				format_item = function(item)
					return item:gsub(git_root .. "/", "")
				end,
			}, function(selected)
				if selected then
					vim.cmd("e " .. vim.fn.fnameescape(selected))
				elseif not selected then
					return
				end
			end)
		else
			print("No UI support for selecting files")
		end
	end
end

local function init()
	_G.project_manager_ignore_pattern = load_file(ignore_pattern_file)
	_G.project_manager_ignore_list = load_file(ignore_list_file)
	update_cache_async()
	-- update_cache()
end

init()

vim.api.nvim_create_user_command("ProjectManagerShowProjects", show_projects, {})
vim.api.nvim_create_user_command("ProjectManagerAddToIgnoreList", add_to_ignore_list, {})
vim.api.nvim_create_user_command("ProjectManagerRemoveFromIgnoreList", remove_from_ignore_list, {})
vim.api.nvim_create_user_command("ProjectManagerViewIgnoreList", function()
	view_ignores(ignore_list_file)
end, {})
vim.api.nvim_create_user_command("ProjectManagerViewIgnorePatterns", function()
	view_ignores(ignore_pattern_file)
end, {})
vim.api.nvim_create_user_command("ProjectManagerOpenReadme", open_readme, {})

local keymap = vim.keymap.set
keymap("n", "<Leader>p", "<Nop>", { noremap = true, silent = true, desc = "Project manager" })
keymap("n", "<Leader>pp", show_projects, { noremap = true, silent = true, desc = "Show projects" })
keymap("n", "<Leader>pu", update_cache_async, { noremap = true, silent = true, desc = "Update cache async" })
keymap("n", "<Leader>pi", add_to_ignore_list, { noremap = true, silent = true, desc = "Add to ignore list" })
keymap("n", "<Leader>pr", remove_from_ignore_list, { noremap = true, silent = true, desc = "Remove from ignore list" })
keymap("n", "<Leader>pv", function()
	view_ignores(ignore_list_file)
end, { noremap = true, silent = true, desc = "View ignore list" })
keymap("n", "<Leader>pw", function()
	view_ignores(ignore_pattern_file)
end, { noremap = true, silent = true, desc = "View ignore pattern list" })
keymap("n", "<Leader>pR", open_readme, { noremap = true, silent = true, desc = "View projects README" })
