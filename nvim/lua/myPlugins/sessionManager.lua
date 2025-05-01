-- .config/nvim/lua/myPlugins/sessionManager.lua
-- Session name: cwd path replaced with %% eg: %home%lasim%.vim
-- Sessions saved in vim.fn.stdpath("data"): ~/.local/state/nvim/sessions/

local M = {}

function M.SaveSession()
	local cwd = vim.fn.getcwd()
	local session_name = cwd:gsub("[/\\]", "%%") -- sanitize path
	local session_path = vim.fn.stdpath("data") .. "/session/" .. session_name .. ".vim"

	-- TODO: Check if folder exists, and make if not
	if vim.fn.isdirectory(vim.fn.stdpath("data") .. "/session/") == 0 then
		vim.fn.mkdir(vim.fn.stdpath("data") .. "/session/", "p")
	end

	print("Saves session to: ", session_path)
	vim.cmd("mksession! " .. vim.fn.fnameescape(session_path))
	-- vim.print(vim.fn.fnameescape(session_path))
end

function M.LoadSession()
	local cwd = vim.fn.getcwd()
	local session_name = cwd:gsub("[/\\]", "%%")
	local session_path = vim.fn.stdpath("data") .. "/session/" .. session_name .. ".vim"

	if vim.fn.filereadable(session_path) == 1 then
		vim.cmd("silent! source " .. vim.fn.fnameescape(session_path))
		print("Loaded session: " .. session_path)
		return 0
	else
		print("Session file not found: " .. session_path)
		return 1
	end
end

local function listSessions()
	local sessions_folder = vim.fn.stdpath("data") .. "/session/"
	-- print("Sessions in: " .. sessions_folder)
	-- get all files in folder
	local sessions = vim.fn.readdir(sessions_folder)
	if #sessions == 0 then
		print("No sessions found")
		return
	end
	-- vim.print("sessions: ", sessions)

	vim.ui.select(sessions, {
		prompt = "Select a Git repository to open:",
		format_item = function(item)
			item = item:gsub(".vim$", ""):match(".*%%(.*)")
			return item
		end,
	}, function(selected)
		if not selected then
			return
		end
		M.SaveSession()
		vim.cmd("%bd!")
		local cmd = "source " .. sessions_folder .. vim.fn.fnameescape(selected)
		vim.cmd(cmd)
	end)
end

local function clearSessions()
	local sessions_folder = vim.fn.stdpath("data") .. "/session/"
	local sessions = vim.fn.readdir(sessions_folder)
	for _, session in ipairs(sessions) do
		if session:match("%.vim$") then
			local path = sessions_folder .. session
			local ok, err = os.remove(path)
			if not ok then
				print("Failed to delete: " .. path .. " (" .. err .. ")")
				return
			end
			print("Deleted: " .. path)
		end
	end
end

local user_cmd = vim.api.nvim_create_user_command
user_cmd("SaveSession", M.SaveSession, {})
user_cmd("LoadSession", M.LoadSession, {})
user_cmd("ListSessions", listSessions, {})
user_cmd("ClearSessions", clearSessions, {})

local keymap = vim.keymap.set
keymap("n", "<Leader>s", "<Nop>", { desc = "Sessions manager" })
keymap("n", "<Leader>ss", M.SaveSession, { desc = "Save session" })
keymap("n", "<Leader>sl", M.LoadSession, { desc = "Load session" })
keymap("n", "<Leader>sa", listSessions, { desc = "List sessions" })
keymap("n", "<Leader>sc", clearSessions, { desc = "Clear sessions" })

vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		M.SaveSession()
	end,
})

return M
