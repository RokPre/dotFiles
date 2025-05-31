-- projectManager .config/nvim/lua/myPlugins/projectManager.lua
local ignore_file = vim.fn.stdpath("config") .. "/.project_manager_ignores.lua"
local cache_file = vim.fn.stdpath("cache") .. "/.project_manager_cache.lua"
_G.project_manager_ignores = {}
_G.project_manager_cache = {}

local ok, sessionManager = pcall(require, "myPlugins.sessionManager")
if not ok then
  sessionManager = nil
end

local function read_table_from_file(file_path)
  local ok, from_file = pcall(dofile, file_path)
  if ok and type(from_file) == "table" then
    return from_file
  else
    vim.notify("Error opening file: " .. file_path, vim.log.levels.ERROR)
    return {}
  end
end

local function write_table_to_file(tbl, filepath)
  local f = io.open(filepath, "w")
  if not f then
    vim.notify("Error opening file: " .. filepath, vim.log.levels.ERROR)
    return
  end
  f:write("return {\n")
  for _, item in ipairs(tbl) do
    f:write("  " .. string.format("%q", item) .. ",\n")
  end
  f:write("}\n")
  f:close()
end

local function contains(ignore_patterns, val)
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
  local stdout = uv.new_pipe()
  local stderr = uv.new_pipe()
  local output = ""

  -- TODO: Add customizable scan depth
  -- TODO: Add customizable scan path (eg: ~/sync)
  local handle
  handle = uv.spawn("find", {
    stdio = { nil, stdout, stderr },
    args = { os.getenv("HOME"), "-type", "d", "-name", ".git" },
  }, function(code, signal)
    -- Child process exited
    uv.read_stop(stdout)
    uv.close(stdout)
    uv.close(stderr)
    uv.close(handle)

    vim.schedule(function()
      _G.project_manager_cache = {} -- Clear cache in the case ignore list or ignore pattern has changed
      for git_dir in output:gmatch("([^\n]+)") do
        git_dir = git_dir:gsub("/.git", "")
        if not contains(_G.project_manager_ignores, git_dir) then
          table.insert(_G.project_manager_cache, git_dir)
        end
      end
      write_table_to_file(_G.project_manager_cache, cache_file)
      vim.notify("Project cache updated", vim.log.levels.INFO)
    end)
  end)

  uv.read_start(stdout, function(err, data)
    assert(not err, err)
    if data then
      output = output .. data
    end
  end)
end

local function show_projects()
  -- Shows the projects that are stored in the cache
  local repo_dirs = _G.project_manager_cache
  if not repo_dirs or #repo_dirs == 0 then
    vim.notify("No projects found. Please wait or use <Leader>pu to update the cache")
    return
  end
  vim.ui.select(repo_dirs, {
    prompt = "Select a Git repository to open:",
    format_item = function(item)
      return vim.fn.fnamemodify(item, ":t")
    end,
  }, function(selected)
    if not selected then
      return
    end
    -- Save current session
    pcall(function()
      if sessionManager and sessionManager.SaveSession then
        sessionManager.SaveSession()
      end
    end)

    -- Close all buffers and windows
    vim.cmd("%bd!")
    vim.cmd("cd " .. selected)

    -- Open new session
    local ok, result = pcall(function()
      if sessionManager and sessionManager.LoadSession then
        return sessionManager.LoadSession()
      end
      return 0
    end)

    -- In case of error, edit the root dir of project
    if ok and result == 1 then
      vim.cmd("e " .. selected)
    end
  end)
end

---------------------------
-- Ignore list functions --
---------------------------
local function get_git_root(file_path)
  if vim.fn.isdirectory(file_path) == 0 then
    file_path = vim.fn.fnamemodify(file_path, ":h")
  end

  local cmd = "cd " .. vim.fn.shellescape(file_path) .. " && git rev-parse --show-toplevel 2>/dev/null"
  local git_root = vim.fn.system(cmd):gsub("\n", "")

  if vim.v.shell_error == 0 and git_root ~= "" then
    return vim.fn.fnamemodify(git_root, ":p") -- ensure full path
  else
    return nil
  end
end


local function add_to_ignore_list()
  local git_root = get_git_root(vim.fn.expand("%:p"))
  if not git_root then
    vim.notify("Not in a Git repository", vim.log.levels.WARN)
    return
  end
  for _, ignored_repo in ipairs(_G.project_manager_ignores) do
    if ignored_repo == git_root then
      vim.notify("Repository already on ignore list: " .. git_root, vim.log.levels.INFO)
      return
    end
  end
  table.insert(_G.project_manager_ignores, git_root)
  vim.notify("Added repository to ignore list: " .. git_root, vim.log.levels.INFO)
  write_table_to_file(_G.project_manager_ignores, ignore_file)
  update_cache_async()
end

local function remove_from_ignore_list()
  local git_root = get_git_root(vim.fn.expand("%:p"))
  if not git_root then
    vim.notify("Not in a Git repository", vim.log.levels.WARN)
    return
  end
  local found = false
  for i, ignored_repo in ipairs(_G.project_manager_ignores) do
    if ignored_repo == git_root then
      table.remove(_G.project_manager_ignores, i)
      found = true
      break
    end
  end
  if found then
    vim.notify("Removed repository from ignore list: " .. git_root, vim.log.levels.INFO)
    write_table_to_file(_G.project_manager_ignores, ignore_file)
    update_cache_async()
  else
    vim.notify("Repository not found in ignore list: " .. git_root, vim.log.levels.WARN)
  end
end

local function view_ignores()
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
    vim.cmd("edit " .. vim.fn.fnameescape(ignore_file))
  end)

  local buf = vim.api.nvim_win_get_buf(win)

  -- Set key mapping to close the window on pressing q
  vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>confirm bd!<CR>", { noremap = true, silent = true })

  vim.api.nvim_create_augroup("ViewIgnores", { clear = true })
  vim.api.nvim_create_autocmd("WinClosed", {
    group = "ViewIgnores",
    callback = function()
      _G.project_manager_ignores = read_table_from_file(ignore_file)
      update_cache_async()
      vim.api.nvim_del_augroup_by_name("ViewIgnores")
    end,
  })
end

------------
-- others --
------------
local function open_readme()
  local cwd = vim.fn.getcwd()
  local git_root = get_git_root(cwd)

  if git_root == nil then
    vim.notify("Not in a Git repository", vim.log.levels.WARN)
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
    vim.notify("No README.md file found", vim.log.levels.WARN)
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
      vim.notify("No UI support for selecting files", vim.log.levels.WARN)
    end
  end
end

local function init()
  _G.project_manager_ignores = read_table_from_file(ignore_file)
  _G.project_manager_cache = read_table_from_file(cache_file)
  update_cache_async()
end

init()

vim.api.nvim_create_user_command("ProjectManager", show_projects, {})

local keymap = vim.keymap.set
keymap("n", "<Leader>p", "<Nop>", { noremap = true, silent = true, desc = "Project manager" })
keymap("n", "<Leader>pd", remove_from_ignore_list, { noremap = true, silent = true, desc = "Remove from ignore list" })
keymap("n", "<Leader>pi", add_to_ignore_list, { noremap = true, silent = true, desc = "Add to ignore list" })
keymap("n", "<Leader>pp", show_projects, { noremap = true, silent = true, desc = "Show projects" })
keymap("n", "<Leader>pr", open_readme, { noremap = true, silent = true, desc = "View projects README" })
keymap("n", "<Leader>pu", update_cache_async, { noremap = true, silent = true, desc = "Update cache async" })
keymap("n", "<Leader>pv", view_ignores, { noremap = true, silent = true, desc = "View ignore list" })
