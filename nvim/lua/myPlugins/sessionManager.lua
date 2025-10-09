-- .config/nvim/lua/myPlugins/sessionManager.lua
-- Session name: cwd path replaced with %%
-- Sessions saved in vim.fn.stdpath("data"): ~/.local/state/nvim/sessions/
-- TODO: Requires a complete rewrite. I just need to :source session.vim

local session_folder = vim.fn.stdpath("config") .. "/.session/"
local home_path = tostring(os.getenv("HOME"))

local M = {}

function M.SaveSession()
  if vim.fn.isdirectory(session_folder) == 0 then
    vim.fn.mkdir(session_folder, "p")
  end

  -- Check if aerial is installed.
  -- If installed close the aerial window before saving the session.
  local ok, aerial = pcall(require, "aerial")

  -- Close aerial window if it's open
  if ok and aerial.is_open() then
    aerial.close_all()
  end

  local cwd = vim.fn.getcwd()
  local session_name = cwd:gsub(home_path, "~"):gsub("[/\\]", "%%") -- sanitize path
  local session_path = session_folder .. session_name .. ".vim"

  vim.cmd("mksession! " .. vim.fn.fnameescape(session_path))
end

function M.LoadSession()
  local cwd = vim.fn.getcwd()
  local session_name = cwd:gsub(home_path, "~"):gsub("[/\\]", "%%") -- sanitize path
  print("session_name", session_name)
  print("session_folder", session_folder)
  local session_path = session_folder .. session_name .. ".vim"
  print("session_path", session_path)

  if vim.fn.filereadable(session_path) == 1 then
    vim.cmd("silent! source " .. vim.fn.fnameescape(session_path))

    local base = session_path:gsub("%.vim$", "")
    -- prefer session_name; fall back to last % segment if present
    local tail = session_name ~= "" and session_name
        or base:match(".*%%(.+)$")
        or base

    -- pretty print
    local pretty = tail:gsub("%%", "/")

    vim.notify("Loaded session: " .. pretty, vim.log.levels.INFO)
    return 0
  else
    vim.notify("Session file not found: " .. session_path, vim.log.levels.WARN)
    return 1
  end
end

local function listSessions()
  -- get all files in folder
  local sessions = vim.fn.readdir(session_folder)
  if #sessions == 0 then
    vim.notify("No sessions found", vim.log.levels.INFO)
    return
  end

  vim.ui.select(sessions, {
    prompt = "Select session to load",
    format_item = function(item)
      item = item:gsub(".vim$", ""):match(".*%%(.*)")
      return item
    end,
  }, function(selected)
    if not selected then
      return
    end

    local cwd = vim.fn.getcwd()
    local session_name = cwd:gsub(home_path, "~"):gsub("[/\\]", "%%") -- sanitize path
    if session_name ~= selected:gsub(".vim", "") then
      M.SaveSession()
    end
    vim.cmd("%bd!")
    local cmd = "source " .. session_folder .. vim.fn.fnameescape(selected)
    vim.cmd(cmd)
  end)
end

local function loadLastSession()
  local sessions = vim.fn.readdir(session_folder)
  if #sessions == 0 then
    vim.notify("No sessions found", vim.log.levels.INFO)
    return
  end
  -- Sort sessions by last modified time
  table.sort(sessions, function(a, b)
    return vim.fn.getftime(session_folder .. a) > vim.fn.getftime(session_folder .. b)
  end)

  local last_session = sessions[1]
  if last_session == nil then
    vim.notify("No sessions found", vim.log.levels.INFO)
    return
  end

  local cmd = "source " .. session_folder .. vim.fn.fnameescape(last_session)
  vim.cmd(cmd)
end

local user_cmd = vim.api.nvim_create_user_command
user_cmd("SaveSession", M.SaveSession, {})
user_cmd("LoadSession", M.LoadSession, {})
user_cmd("ListSessions", listSessions, {})
user_cmd("LastSession", loadLastSession, {})

local keymap = vim.keymap.set
keymap("n", "<Leader>s", "<Nop>", { desc = "Sessions manager" })
keymap("n", "<Leader>ss", M.SaveSession, { desc = "Save session" })
keymap("n", "<Leader>sl", M.LoadSession, { desc = "Load session" })
keymap("n", "<Leader>sa", listSessions, { desc = "List sessions" })

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    M.SaveSession()
  end,
})

return M
