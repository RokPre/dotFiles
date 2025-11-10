local M = {}

M.opts = {
	search_folder = vim.fn.expand("~"),
	run_on_startup = true,
	run_on_startup_delay = 1000,
	ignore_file = vim.fn.stdpath("config") .. "/.project_manager_ignores",
}

function M.setup(opts)
	M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})
	if M.opts.run_on_startup then
		vim.defer_fn(M.update_cache_async, M.opts.run_on_startup_delay)
	end
end

local u_ok, utils = pcall(require, "myPlugins.utils")
if not u_ok then
	vim.notify("Could not load myPlugins.utils", vim.log.levels.ERROR)
	return
end

local s_ok, sessions = pcall(require, "myPlugins.sessionManager")
if not s_ok then
	vim.notify("Could not load myPlugins.sessionManager", vim.log.levels.ERROR)
	return
end

local cache_file = vim.fn.stdpath("cache") .. "/.project_manager_cache"

function M.filter_projects(projects)
	local filtered_projects = {}
	local ignore_patterns = utils.read_table_from_file(M.opts.ignore_file)

	if not ignore_patterns then
		vim.notify("Could not read ignore patterns from ignore file", vim.log.levels.ERROR)
		return {}
	end

	for _, project in ipairs(projects) do
		local contains = false

		for _, pattern in ipairs(ignore_patterns) do
			if project:find(pattern, 1, true) then -- literal match!
				contains = true
				break
			end
		end

		if not contains and project ~= "" then
			table.insert(filtered_projects, project)
		end
	end

	return filtered_projects
end

function M.update_cache_async()
	if M.opts.search_folder == nil then
		M.opts.search_folder = vim.fn.expand("~")
	end
	vim.system({ "find", M.opts.search_folder, "-type", "d", "-name", ".git" }, { text = true }, function(obj)
		vim.schedule(function()
			utils.write_table_to_file(vim.split(obj.stdout, "\n"), cache_file)
		end)
	end)
end

function M.show_projects()
	local projects = utils.read_table_from_file(cache_file)
	if projects == nil then
		vim.notify("Could not read projects from cache file", vim.log.levels.ERROR)
		return nil
	end
	projects = M.filter_projects(projects)

	vim.ui.select(projects, {
		prompt = "Select a project to open:",
		format_item = function(item)
			return vim.fn.fnamemodify(item:gsub("/.git", ""), ":t")
		end,
	}, function(selected)
		if selected then
			local selected_path = selected:gsub("/.git", "")
			sessions.sourceSession(selected_path)
		end
	end)
end

function M.open_readme()
	local cwd = vim.fn.getcwd()
	local git_folder = utils.get_git_repo(cwd)

	vim.system({ "find", git_folder, "-type", "f", "-name", "README.md" }, { text = true }, function(obj)
		vim.schedule(function()
			local readme_list = vim.split(obj.stdout, "\n")

			if readme_list == nil or #readme_list == 0 then
				vim.notify("No README.md file found", vim.log.levels.WARN)
				return
			end

			if #readme_list == 1 then
				vim.cmd("e " .. vim.fn.fnameescape(readme_list[1]))
				return
			end

			if #readme_list > 1 then
				readme_list = vim.tbl_filter(function(s)
					return s ~= ""
				end, readme_list)
				table.sort(readme_list, function(a, b)
					return select(2, a:gsub("/", "")) < select(2, b:gsub("/", ""))
				end)

				vim.ui.select(readme_list, {
					prompt = "Select a README.md file to open:",
					format_item = function(item)
						return item:gsub(git_folder .. "/", "")
					end,
				}, function(selected)
					if selected then
						vim.cmd("e " .. vim.fn.fnameescape(selected))
					end
				end)
			end
		end)
	end)
end

vim.schedule(function()
	if M.opts.run_on_startup then
		vim.defer_fn(M.update_cache_async, M.opts.run_on_startup_delay)
	end
end)

local keymap = vim.keymap.set
keymap("n", "<Leader>p", "<Nop>", { noremap = true, silent = true, desc = "Project manager" })
keymap("n", "<Leader>pp", M.show_projects, { noremap = true, silent = true, desc = "Show projects" })
keymap("n", "<Leader>pr", M.open_readme, { noremap = true, silent = true, desc = "View projects README" })
keymap("n", "<Leader>pu", M.update_cache_async, { noremap = true, silent = true, desc = "Update cache async" })
keymap("n", "<Leader>pi", function()
	vim.cmd("e " .. M.opts.ignore_file)
end, { noremap = true, silent = true, desc = "Edit ignore file" })

return M
