-- SessionManager .config/nvim/lua/myPlugins/projectManager.lua
local home_dir = os.getenv("HOME")
local ignore_list_file = vim.fn.stdpath("config") .. "/.project_manager_ignore_list.lua"
local ignore_pattern_file = vim.fn.stdpath("config") .. "/.project_manager_ignore_pattern.lua"
local cache = vim.fn.stdpath("data") .. "/.project_manager_cache.lua"
local sessionManager = require("myPlugins.sessionManager")

--------------------------
-- Load data from files --
--------------------------

local function load_cache()
	-- Load cache from file if it exists
	local ok_cache, cache_from_file = pcall(dofile, cache)
	if ok_cache and type(cache_from_file) == "table" then
		_G.project_manager_cache = cache_from_file
	else
		_G.project_manager_cache = {}
	end
end

local function load_ignore_pattern()
	-- Load ignore pattern from file if it exists
	local ok_pattern, ignore_pattern_from_file = pcall(dofile, ignore_pattern_file)
	if ok_pattern and type(ignore_pattern_from_file) == "table" then
		_G.project_manager_ignore_pattern = ignore_pattern_from_file
	else
		_G.project_manager_ignore_pattern = {}
	end
end

local function load_ignore_list()
	-- Load ignore list from file if it exists
	local ok, ignore_list_from_file = pcall(dofile, ignore_list_file)
	if ok and type(ignore_list_from_file) == "table" then
		_G.project_manager_ignore_list = ignore_list_from_file
	else
		_G.project_manager_ignore_list = {}
	end
end

-- Helper function to check if a value is in a table
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

local function get_project_name(path)
	-- Modify the the options that the ui shows.
	return vim.fn.fnamemodify(path, ":t")
	-- return path:gsub(home_dir, "~")
end

local function show_projects()
	-- Shows the projects that are stored in the cache
	local repo_dirs = _G.project_manager_cache
	vim.ui.select(repo_dirs, {
		prompt = "Select a Git repository to open:",
		format_item = function(item)
			-- return item:gsub(home_dir, "~")
			return get_project_name(item)
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

-- Function to find all Git repositories in home directory
local function update_cache()
	local repo_dirs = {}
	local cmd = "find " .. home_dir .. "/sync -type d -name .git -exec dirname {} \\; 2>/dev/null"
	local git_repos = vim.fn.systemlist(cmd)

	for _, git_dir in ipairs(git_repos) do
		if
			not contains(_G.project_manager_ignore_list, git_dir)
			and not contains_ignore_pattern(git_dir, _G.project_manager_ignore_pattern)
		then
			table.insert(repo_dirs, git_dir)
		end
	end

	_G.project_manager_cache = repo_dirs
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
	update_cache()
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

local function view_ignore_list()
	local f = io.open(ignore_list_file, "r")
	if not f then
		print("Error opening file: " .. ignore_list_file)
		return
	end

	local content = f:read("*all")
	f:close()
	local lines = vim.split(content, "\n")

	-- Create a new normal buffer and assign the file path
	local buf = vim.api.nvim_create_buf(true, false)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_buf_set_name(buf, ignore_list_file)

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

	vim.api.nvim_create_augroup("ViewIgnoreList", { clear = true })
	vim.api.nvim_create_autocmd("BufWinLeave", {
		group = "ViewIgnoreList",
		callback = function()
			update_ignore_list()
			vim.api.nvim_del_augroup_by_name("ViewIgnoreList")
		end,
	})
end

local function update_ignore_pattern()
	-- Works more like format, not update. When you write to the file `.project_manager_ignore_pattern.lua`, is when you update it.
	-- I could make it so that when you write to the file, it load the table form the file back into the
	-- _G.project_manager_ignore_pattern variable.
	load_ignore_pattern()
	local f = io.open(ignore_pattern_file, "w")
	if f then
		f:write("return {\n")
		for _, item in ipairs(_G.project_manager_ignore_pattern) do
			f:write("  " .. string.format("%q", item) .. ",\n")
		end
		f:write("}\n")
		f:close()
	else
		print("Error opening file: " .. ignore_list_file)
	end
	update_cache()
end

local function view_ignore_pattenrs()
	local f = io.open(ignore_pattern_file, "r")
	if not f then
		print("Error opening file: " .. ignore_pattern_file)
		return
	end

	local content = f:read("*all")
	f:close()
	local lines = vim.split(content, "\n")

	-- Create a new normal buffer and assign the file path
	local buf = vim.api.nvim_create_buf(true, false)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_buf_set_name(buf, ignore_pattern_file)

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

	vim.api.nvim_create_augroup("ViewIgnorePatterns", { clear = true })
	vim.api.nvim_create_autocmd("BufWinLeave", {
		group = "ViewIgnorePatterns",
		callback = function()
			update_ignore_pattern()
			vim.api.nvim_del_augroup_by_name("ViewIgnorePatterns")
		end,
	})
end

load_cache()
load_ignore_pattern()
load_ignore_list()
update_cache()

vim.api.nvim_create_user_command("ProjectManagerShowProjects", show_projects, {})
vim.api.nvim_create_user_command("ProjectManagerUpdateList", update_cache, {})
vim.api.nvim_create_user_command("ProjectManagerAddToIgnoreList", add_to_ignore_list, {})
vim.api.nvim_create_user_command("ProjectManagerRemoveFromIgnoreList", remove_from_ignore_list, {})
vim.api.nvim_create_user_command("ProjectManagerViewIgnoreList", view_ignore_list, {})
vim.api.nvim_create_user_command("ProjectManagerViewIgnorePatterns", view_ignore_pattenrs, {})

local keymap = vim.keymap.set
keymap("n", "<Leader>p", "<Nop>", { noremap = true, silent = true, desc = "Project manager" })
keymap("n", "<Leader>pp", show_projects, { noremap = true, silent = true, desc = "Show projects" })
keymap("n", "<Leader>pu", update_cache, { noremap = true, silent = true, desc = "Update project list cache" })
keymap("n", "<Leader>pi", add_to_ignore_list, { noremap = true, silent = true, desc = "Add to ignore list" })
keymap("n", "<Leader>pr", remove_from_ignore_list, { noremap = true, silent = true, desc = "Remove from ignore list" })
keymap("n", "<Leader>pv", view_ignore_list, { noremap = true, silent = true, desc = "View ignore list" })
keymap("n", "<Leader>pw", view_ignore_pattenrs, { noremap = true, silent = true, desc = "View ignore pattern list" })
