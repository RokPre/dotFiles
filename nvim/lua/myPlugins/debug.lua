#!/usr/bin/lua
-- Helper to show output in a floating window and copy it to the clipboard
-- TODO: IDK man a lot. This is a result of vibe coding.
-- TODO: Fix running the code, it has trouble when the cwd is different from the file that i would like to run.
-- TODO: Fix sourcing the enviroment.
-- TODO: Make the file executable if its not yet allready.
-- TODO: Dont show the output when making the file executable.
-- TODO: Run asynchronously, so that the user can continue working while the code is running.
-- TODO: Make a ai mode, where it copies the code and errors into the clippboard with a master prompt at the start. Read for paste.
local function show_output_in_floating_window(output)
	-- Create a scratch buffer for output
	local buf = vim.api.nvim_create_buf(false, true)
	-- Calculate window dimensions as a fraction of the editor size
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2 - 1)
	local col = math.floor((vim.o.columns - width) / 2)
	local opts = {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	}
	-- Fill the buffer with the output (split by newline)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(output, "\n"))
	-- Open a floating window with our buffer
	local win = vim.api.nvim_open_win(buf, true, opts)
	-- Map "q" in normal mode to close this floating window (buffer-local mapping)
	vim.keymap.set("n", "q", function()
		vim.api.nvim_win_close(win, true)
	end, { buffer = buf, silent = true, nowait = true })
	-- Copy output to the system clipboard ('+')
	vim.fn.setreg("+", output)
end

local function makeFileExecutable(file)
	local command = "chmod +x " .. file
	local output = vim.fn.system(command)
	show_output_in_floating_window(output)
end

local function makeCurrentBufferExecutable()
	local file = vim.fn.expand("%:p")
	makeFileExecutable(file)
end

-- Runs the file with the name main.* in the current directory.
local function runMain()
	print("Running main")
	-- Search for any file matching "main.*" in the current working directory
	local cwd = vim.fn.getcwd()
	local pattern = cwd .. "/main.*"
	local files = vim.fn.glob(pattern, false, true)

	if #files == 0 then
		print("No main file found in " .. cwd)
		return
	end

	-- If more than one main file exists, take the first one (or add a vim.ui.select here for a choice)
	local file = files[1]
	-- Adjust the command based on your need; for example, if it’s a Python file:
	local cmd = "python " .. vim.fn.shellescape(file)
	local output = vim.fn.system(cmd)
	show_output_in_floating_window(output)
end

local function run_file(file)
	local cwd = vim.fn.getcwd()
	local file_path = vim.fn.shellescape(file)
	local cmd = "." .. file_path:gsub("'", ""):gsub(cwd, "")
	print(cmd)
	local output = vim.fn.system(cmd)
	show_output_in_floating_window(output)
end

-- Example usage in runBuffer:
local function runBuffer()
	local file = vim.fn.expand("%:p")
	if file == "" then
		print("Buffer has no associated file.")
		return
	end
	run_file(file)
end

-- Finds the file to source the environment in the current directory.
-- If multiple files are found, shows a selection UI.
local function sourceEnv()
	print("Sourcing environment")
	local cwd = vim.fn.getcwd()
	-- Assuming environment files are named something like .env, env.sh, etc.
	local pattern = cwd .. "/env*"
	local files = vim.fn.glob(pattern, false, true)

	if #files == 0 then
		print("No environment files found in " .. cwd)
		return
	end

	local function doSource(file)
		-- The source command generally works within a shell session. Here we run it and capture output.
		local cmd = "source " .. vim.fn.shellescape(file) .. " && env" -- listing env as an example
		local output = vim.fn.system(cmd)
		show_output_in_floating_window(output)
	end

	if #files == 1 then
		doSource(files[1])
	else
		-- If multiple files exist, allow the user to choose using vim.ui.select.
		vim.ui.select(files, {
			prompt = "Select an environment file to source:",
			format_item = function(item)
				return vim.fn.fnamemodify(item, ":t")
			end,
		}, function(choice)
			if choice then
				doSource(choice)
			end
		end)
	end
end

-- Create user commands
vim.api.nvim_create_user_command("DebugMain", runMain, {})
vim.api.nvim_create_user_command("DebugCurrentBuffer", runBuffer, {})
vim.api.nvim_create_user_command("DebugSourceEnv", sourceEnv, {})
vim.api.nvim_create_user_command("MakeCurrentBufferExecutable", makeCurrentBufferExecutable, {})

-- Create key mappings
local keymap = vim.keymap.set
keymap("n", "<Leader>d", "<Nop>", { noremap = true, silent = true, desc = "Debug menu" })
keymap("n", "<Leader>dm", runMain, { noremap = true, silent = true, desc = "Run main" })
keymap("n", "<Leader>db", runBuffer, { noremap = true, silent = true, desc = "Run current buffer" })
keymap("n", "<Leader>ds", sourceEnv, { noremap = true, silent = true, desc = "Source environment" })
keymap("n", "<Leader>de", makeCurrentBufferExecutable, { noremap = true, silent = true, desc = "Make file executable" })
