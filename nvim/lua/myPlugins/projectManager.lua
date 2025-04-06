local home_dir = os.getenv("HOME")
if not _G.git_repos_ignore_list then
	_G.git_repos_ignore_list = {}
end

local list_file = vim.fn.stdpath("config") .. "/.project_manager_ignore_list.lua"

-- Load ignore list from file if it exists
local ok, ignore_list_from_file = pcall(dofile, list_file)
if ok and type(ignore_list_from_file) == "table" then
	_G.git_repos_ignore_list = ignore_list_from_file
else
	_G.git_repos_ignore_list = {}
end

-- Helper function to update the ignore list file with the current table
local function update_ignore_file()
	local f = io.open(list_file, "w")
	if f then
		-- Write the table so that it can be loaded as a Lua module if needed
		f:write("return " .. vim.inspect(_G.git_repos_ignore_list))
		f:close()
	else
		print("Error opening file: " .. list_file)
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

-- Function to find all Git repositories in home directory
local function find_git_repos()
	local cmd = "find " .. home_dir .. "/sync -type d -name .git -exec dirname {} \\; 2>/dev/null"
	local git_repos = vim.fn.systemlist(cmd)

	if #git_repos == 0 then
		print("No Git repositories found in " .. home_dir)
		return
	end

	local repo_dirs = {}
	for _, git_dir in ipairs(git_repos) do
		if not contains(_G.git_repos_ignore_list, git_dir) then
			table.insert(repo_dirs, git_dir)
		end
	end

	if #repo_dirs == 0 then
		print("All repos are ignored in ignore list")
		return
	end

	vim.ui.select(repo_dirs, {
		prompt = "Select a Git repository to open:",
		format_item = function(item)
			return item:gsub(home_dir, "~")
		end,
	}, function(selected)
		if selected then
			vim.cmd("e " .. selected)
			print("Opened: " .. selected)
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

local function add_to_ignore_list()
	local git_root = get_git_root()
	if not git_root then
		print("Not in a git repository")
		return
	end
	for _, ignored_repo in ipairs(_G.git_repos_ignore_list) do
		if ignored_repo == git_root then
			print("Repository already in ignore list: " .. git_root)
			return
		end
	end
	table.insert(_G.git_repos_ignore_list, git_root)
	print("Added repository to ignore list: " .. git_root .. "\n")
	update_ignore_file()
end

local function remove_from_ignore_list()
	local git_root = get_git_root()
	if not git_root then
		print("Not in a git repository")
		return
	end
	local found = false
	for i, ignored_repo in ipairs(_G.git_repos_ignore_list) do
		if ignored_repo == git_root then
			table.remove(_G.git_repos_ignore_list, i)
			found = true
			break
		end
	end
	if found then
		print("Removed repository from ignore list: " .. git_root)
		update_ignore_file()
	else
		print("Repository not found in ignore list: " .. git_root)
	end
end

local function view_ignore_list()
	local f = io.open(list_file, "r")
	if not f then
		print("Error opening file: " .. list_file)
		return
	end

	local content = f:read("*all")
	f:close()
	local lines = vim.split(content, "\n")

	-- Create a new normal buffer and assign the file path
	local buf = vim.api.nvim_create_buf(true, false)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_buf_set_name(buf, list_file)

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

vim.api.nvim_create_user_command("ProjectManagerFindGitRepos", find_git_repos, {})
vim.api.nvim_create_user_command("ProjectManagerAddToIgnoreList", add_to_ignore_list, {})
vim.api.nvim_create_user_command("ProjectManagerRemoveFromIgnoreList", remove_from_ignore_list, {})
vim.api.nvim_create_user_command("ProjectManagerViewIgnoreList", view_ignore_list, {})

local keymap = vim.keymap.set
keymap("n", "<Leader>pp", find_git_repos, { noremap = true, silent = true })
keymap("n", "<Leader>pi", add_to_ignore_list, { noremap = true, silent = true })
keymap("n", "<Leader>pr", remove_from_ignore_list, { noremap = true, silent = true })
keymap("n", "<Leader>pv", view_ignore_list, { noremap = true, silent = true })
