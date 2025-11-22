-- Session name: cwd path replaced with %%
-- Sessions saved in vim.fn.stdpath("data"): ~/.local/state/nvim/sessions/

local session_folder = vim.fn.stdpath("config") .. "/.session/"
local home_path = tostring(os.getenv("HOME"))

local M = {}

function M.saveSession(cwd)
	-- Check if session folder exists, if not create it
	if vim.fn.isdirectory(session_folder) == 0 then
		vim.fn.mkdir(session_folder, "p")
	end

	-- Check if cwd was given, else use the current working directory
	if cwd == nil then
		cwd = vim.fn.getcwd()
		vim.notify("Cwd was not provided, getting current cwd:", cwd)
	end

	local session_name = cwd:gsub(home_path, "~"):gsub("[/\\]", "%%") -- sanitize path
	local session_path = session_folder .. session_name .. ".vim"

	vim.cmd("mksession! " .. vim.fn.fnameescape(session_path))
	vim.notify("Session saved to " .. vim.fn.fnameescape(session_path), vim.log.levels.INFO)
end

function M.sourceSession(cwd)
	local session_name = cwd:gsub(home_path, "~"):gsub("[/\\]", "%%") -- sanitize path
	local session_path = session_folder .. session_name .. ".vim"

	if vim.fn.filereadable(session_path) == 0 then
		vim.notify("Session file not found", vim.log.levels.WARN)
		return false
	end

	local current_cwd = vim.fn.getcwd()

	-- Do not overwrite the session that the user want to source
	if current_cwd ~= cwd then
		M.saveSession(current_cwd)
	end

	-- Write modified buffers
	vim.cmd("wall")

	-- close all tabs/windows safely. Use `:tabonly` to keep one tab, then `:bufdo bwipeout`
	pcall(vim.cmd, "tabonly")
	pcall(vim.cmd, "silent! bufdo bwipeout")

	-- STEP 3: now load the session
	vim.notify("Loading session: " .. session_path, vim.log.levels.INFO)
	vim.cmd("silent! source " .. vim.fn.fnameescape(session_path))
	return true
end

function M.loadLastSession()
	local sessions = vim.fn.readdir(session_folder)
	if #sessions == 0 then
		vim.notify("No sessions found", vim.log.levels.INFO)
		return false
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
	local expanded_last_session = last_session:gsub("~", home_path):gsub("%%", "/"):gsub(".vim", "") -- sanitize path
	local sok = M.sourceSession(expanded_last_session)
	if sok then
		return true
	end
end

vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		M.saveSession()
	end,
})

vim.api.nvim_create_user_command("SessionSourceCwd", function()
	M.sourceSession(vim.fn.getcwd())
end, { desc = "Source session" })

vim.api.nvim_create_user_command("SessionLoadLast", function()
	M.loadLastSession()
end, { desc = "Load last session" })

return M
