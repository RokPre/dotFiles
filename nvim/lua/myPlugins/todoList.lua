local cache_file = vim.fn.stdpath("cache") .. "/.todoList.lua"

local M = {}

M.opts = {
	ignore_file = vim.fn.stdpath("config") .. "/.todo_list",
	search_folder = vim.fn.expand("~"),
	run_on_startup = true,
	run_on_startup_delay = 1000,
}

M.todos = {}

function M.setup(opts)
	M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})
	M.opts = vim.fn.expand(M.opts)
end

local u_ok, utils = pcall(require, "myPlugins.utils")
if not u_ok then
	vim.notify("Could not load myPlugins.utils", vim.log.levels.ERROR)
	return
end

-- Load the todos from the cache file.
M.todos = utils.read_dict_from_file(cache_file)

function M.update_cache_async()
	if M.opts.search_folder == nil then
		M.opts.search_folder = vim.fn.expand("~")
	end

	vim.system({ "rg", "--vimgrep", "TODO:", M.opts.search_folder }, { text = true }, function(obj)
		vim.schedule(function()
			if not obj or not obj.stdout or obj.stdout == "" then
				vim.notify("No TODOs found", vim.log.levels.INFO)
				return
			end

      -- To prevent duplication of todos, and to clear the cache
      M.todos = {}

			local total_todos = 0
			for _, line in ipairs(vim.split(obj.stdout, "\n")) do
				-- rg --vimgrep format: file:line:col:content
				local file_path, line_number, column, todo_text = line:match("^(.-):(%d+):(%d+):(.*)$")
				if file_path and line_number and todo_text then
					if not M.todos[file_path] then
						M.todos[file_path] = {}
						table.insert(M.todos[file_path], { line = tonumber(line_number), col = tonumber(column), text = vim.trim(todo_text) })
					else
						table.insert(M.todos[file_path], { line = tonumber(line_number), col = tonumber(column), text = vim.trim(todo_text) })
					end
					total_todos = total_todos + 1
				end
			end

			if total_todos == 0 then
				vim.notify("No valid TODO entries parsed", vim.log.levels.WARN)
				return
			end

			utils.write_dict_to_file(M.todos, cache_file)
			vim.notify(string.format("Found %d TODOs in `%s`", total_todos, M.opts.search_folder), vim.log.levels.INFO)
		end)
	end)
end

-- Scopes
-- buffer, folder, project, cwd, home
function M.get_todos_by_scope(scope)
	-- Returns filtered dict of todos
	local todos_by_scope = {}
	if scope == nil or scope == "" or scope == "all" then
		todos_by_scope = M.todos
	elseif scope == "buffer" then
		todos_by_scope[vim.api.nvim_buf_get_name(0)] = M.todos[vim.api.nvim_buf_get_name(0)]
	elseif scope == "folder" then
		for key, value in pairs(M.todos) do
			if vim.startswith(key, vim.fn.expand("%:p:h")) then
				todos_by_scope[key] = M.todos[key]
			end
		end
	elseif scope == "git" then
		local git_repo = utils.get_git_repo(vim.fn.getcwd())
    if git_repo == nil then
      return nil
    end
		for key, value in pairs(M.todos) do
			if vim.startswith(key, git_repo) then
				todos_by_scope[key] = M.todos[key]
			end
		end
	end

	-- Filter out files that are in the ignore file
	local ignore_list = utils.read_table_from_file(M.opts.ignore_file)
  vim.print(vim.inspect(ignore_list))
  if ignore_list == nil or #ignore_list == 0 or ignore_list[1] == "" then
    return todos_by_scope
  end

  local filtered_todos = {}
  for key, value in pairs(todos_by_scope) do
    for _, ignore in ipairs(ignore_list) do
      if key:match(ignore) then
        goto continue
      end
    end
    filtered_todos[key] = value
    ::continue::
  end
	return filtered_todos
end

function M.display_todos(scope)
	scope = scope or "all"
	local todos_by_scope = M.get_todos_by_scope(scope)

  if todos_by_scope == nil then
    return
  end

	-- These the todos that the user will choose from. Have to convert dict to list.
	local todos = {}
	for key, value in pairs(todos_by_scope) do
		for _, todo in ipairs(value) do
			table.insert(todos, { file_path = key, line = todo.line, col = todo.col, text = todo.text })
		end
	end

	vim.ui.select(todos, {
		prompt = "Select a TODO to open:",
		format_item = function(item)
			local clean_text = item.text:match("TODO:%s*(.*)") or item.text
			return string.format("%3d  %-20s  %s", item.line or 0, vim.fn.fnamemodify(item.file_path or "", ":t"), clean_text)
		end,
	}, function(selected)
		if selected then
			vim.cmd("e " .. vim.fn.fnameescape(selected.file_path))
			vim.api.nvim_win_set_cursor(0, { selected.line, selected.col })
		end
	end)
end

vim.schedule(function()
	if M.opts.run_on_startup then
		vim.defer_fn(M.update_cache_async, M.opts.run_on_startup_delay)
	end
end)

local keymap = vim.keymap.set
keymap("n", "<Leader>t", "<Nop>", { noremap = true, silent = true, desc = "Todo list" })
keymap("n", "<Leader>tu", M.update_cache_async, { noremap = true, silent = true, desc = "Update cache async" })
keymap("n", "<Leader>ti", function() vim.cmd("e " .. M.opts.ignore_file) end, { noremap = true, silent = true, desc = "Edit ignore file" })
keymap("n", "<Leader>ta", function()
	M.display_todos("all")
end, { noremap = true, silent = true, desc = "Current buffer" })
keymap("n", "<Leader>tt", function()
	M.display_todos("buffer")
end, { noremap = true, silent = true, desc = "Current buffer" })
keymap("n", "<Leader>tf", function()
	M.display_todos("folder")
end, { noremap = true, silent = true, desc = "Current folder of buffer" })
keymap("n", "<Leader>tg", function()
	M.display_todos("git")
end, { noremap = true, silent = true, desc = "Current git repo" })

return M
