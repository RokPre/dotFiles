-- TODO: Add ignore list
-- TODO: Add ignore pattern
-- TODO: Add caching

local function display_files(files)
	vim.ui.select(files, {
		prompt = "Select a file to open:",
		kind = "file finder",
		format_item = function(file)
			local display_string = vim.fn.fnamemodify(file, ":t")
			return display_string
		end,
	}, function(selected)
		if selected then
			vim.cmd("e " .. selected)
		end
	end)
end

local function f_list_buffers()
	vim.print("List buffers")
	local bufsnrs = vim.api.nvim_list_bufs()
	local files = {}
	for _, bufnr in ipairs(bufsnrs) do
		if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_get_name(bufnr) ~= "" then
			table.insert(files, vim.api.nvim_buf_get_name(bufnr))
		end
	end
	display_files(files)
end

local function f_cwd()
	local cwd = vim.fn.getcwd()
	local cmd = "find " .. vim.fn.shellescape(cwd) .. " -type f"
	local files = vim.fn.systemlist(cmd)
	display_files(files)
end

local function f_home()
	local cmd = "find ~ -type f"
	local files = vim.fn.systemlist(cmd)
	display_files(files)
end

local function f_git()
	local current_file = vim.fn.expand("%:p:h")
	local cmd = "git -C '" .. current_file .. "' rev-parse --show-toplevel 2>/dev/null"
	local in_repo = vim.fn.system(cmd)
	if in_repo == "" then
		print("File is not in a git repository")
		return
	end

	local git_root = vim.fn.trim(in_repo)
	local git_files = {}

	cmd = "git -C " .. git_root .. " ls-files"
	local files = vim.fn.system(cmd)
	files = vim.fn.split(files, "\n")
	for i, file in ipairs(files) do
		git_files[i] = git_root .. "/" .. file
	end
	display_files(git_files)
end

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<Leader>f", "<Nop>", { desc = "File finder" })
keymap("n", "<Leader>fb", f_list_buffers, { desc = "Open buffers" })
keymap("n", "<Leader>fc", f_cwd, { desc = "Cwd" })
keymap("n", "<Leader>fh", f_home, { desc = "Home dir" })
keymap("n", "<Leader>fg", f_git, { desc = "Git repo" })
