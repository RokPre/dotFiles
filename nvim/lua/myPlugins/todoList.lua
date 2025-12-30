local M = {}

M.opts = {
	ignore_file = vim.fn.stdpath("config") .. "/.todo_list",
	search_folder = vim.fn.expand("~"),
}

function M.read_ignores()
	local f = io.open(M.opts.ignore_file, "r")
	if not f then
		return {}
	end

	local t = {}
	for line in f:lines() do
		if line ~= "" then
			table.insert(t, line)
		end
	end
	f:close()
	return t
end

-- Converts ignore patterns to ripgrep args
function M.rg_ignore_args()
	local ignores = M.read_ignores()
	local args = {}
	for _, patt in ipairs(ignores) do
		table.insert(args, "--glob")
		table.insert(args, "!" .. patt)
	end
	return args
end

-- Generic TODO search using telescope
function M.search_todos(opts)
	opts = opts or {}
	local telescope = require("telescope.builtin")

	local args = {
		search = "TODO:", -- force search term
		additional_args = function()
			return M.rg_ignore_args()
		end,
	}
	-- Scope: restrict search location if specified
	if opts.cwd then
		args.cwd = opts.cwd
	end
	if opts.search_dirs then
		args.search_dirs = opts.search_dirs
	end

	telescope.grep_string(args)
end

-- Scopes
function M.all()
	M.search_todos({ cwd = M.opts.search_folder })
end

function M.buffer()
	local file = vim.fn.expand("%:p")

	require("telescope.builtin").grep_string({
		search = "TODO:",
		search_dirs = { file }, -- ← limits search strictly to this file
	})
end

function M.folder()
	M.search_todos({ cwd = vim.fn.getcwd() })
end

function M.git()
	local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
	if root and root ~= "" then
		M.search_todos({ cwd = root })
	else
		vim.notify("Not inside a git repo", vim.log.levels.WARN)
	end
end

-- Keymaps
vim.keymap.set("n", "<Leader>ta", M.all, { desc = "Search all TODOs" })
vim.keymap.set("n", "<Leader>tt", M.buffer, { desc = "Search TODOs in file's folder" })
vim.keymap.set("n", "<Leader>tf", M.folder, { desc = "Search TODOs in cwd" })
vim.keymap.set("n", "<Leader>tg", M.git, { desc = "Search TODOs in git repo" })
vim.keymap.set("n", "<Leader>ti", function()
	vim.cmd("e " .. M.opts.ignore_file)
end, { desc = "Edit ignore list" })

return M
