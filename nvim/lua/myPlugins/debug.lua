-- Helper to show output in a floating window and copy it to the clipboard

_G.ai_prompt =
	"This is the output that i got when running my code. If there are any errors can you help me understnad why i got these errors and what are some ways that i can debug this further.\n"

local function show_output_in_floating_window(output, file)
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
	if _G.ai_mode then
		local code = vim.fn.readfile(file)
		code = table.concat(code, "\n")
		output = _G.ai_prompt .. output .. "\nHere is the code:\n```\n" .. code .. "\n```"
	end
	vim.fn.setreg("+", output)
end

local function fileExecutable(file)
	local command = "chmod +x " .. file
	local output = vim.fn.system(command)
	vim.print(output)
end

local function runFile(file)
	if file == "" then
		print("Buffer has no associated file.")
		return
	end

	if vim.fn.executable(file) == 0 then
		vim.print("Made file executable")
		vim.print(fileExecutable(file))
	end

	local stdout = vim.loop.new_pipe(false)
	local stderr = vim.loop.new_pipe(false)
	local output_lines = {}
	local error_lines = {}

	local handle
	handle = vim.loop.spawn(file, {
		stdio = { nil, stdout, stderr },
	}, function(code, signal)
		stdout:read_stop()
		stderr:read_stop()
		stdout:close()
		stderr:close()
		handle:close()

		local final_output = table.concat(output_lines, "\n")
		local final_error = table.concat(error_lines, "\n")
		if final_error ~= "" then
			final_output = final_output .. "\nErrors:\n" .. final_error
		end

		-- Schedule the floating window on the main event loop
		vim.schedule(function()
			vim.print(final_output)
			show_output_in_floating_window(final_output, file)
		end)
	end)

	stdout:read_start(function(err, data)
		assert(not err, err)
		if data then
			table.insert(output_lines, data)
		end
	end)

	stderr:read_start(function(err, data)
		assert(not err, err)
		if data then
			table.insert(error_lines, data)
		end
	end)
end
-- Runs the file with the name main.* in the current directory.
local function runMain()
	print("Running main")
	local folder_path = vim.fn.expand("%:p:h") -- get the directory of the current file, not the file itself
	local cmd = { "find", folder_path, "-name", "main.*" }
	local files = vim.fn.systemlist(cmd) -- systemlist, not system, because find can return multiple lines
	if #files == 0 then
		print("No main file found in " .. folder_path)
		return
	end

	-- If more than one main file exists, take the first one (or add a vim.ui.select here for a choice)
	local file = files[1]
	runFile(file)
end

-- Runs the file with the name main.* in the current directory.
local function runBuffer()
	print("Running buffer")
	local file = vim.api.nvim_buf_get_name(0)
	runFile(file)
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
		show_output_in_floating_window(output, file)
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

local function toggleAiMode()
	_G.ai_mode = not _G.ai_mode
	print("AI mode is now", _G.ai_mode)
end

local function setAiPrompt()
	-- TODO: Add a floating window for better user input experience
	-- TODO: Make the prompe presistent
	_G.ai_prompt = vim.fn.input("Enter the AI prompt: ")
end

local function showRunningCode()
	-- TODO: Add a floating window that shows the current running code in the background
	-- TODO: Ability to select it and stop it, somewhat like oil.nvim, except with process
	print("Show running code")
end

-- Create user commands
vim.api.nvim_create_user_command("DebugMain", runMain, {})
vim.api.nvim_create_user_command("DebugCurrentBuffer", runBuffer, {})
vim.api.nvim_create_user_command("DebugSourceEnv", sourceEnv, {})
vim.api.nvim_create_user_command("DebugAIMode", toggleAiMode, {})
vim.api.nvim_create_user_command("DebugAIPrompt", setAiPrompt, {})

-- Create key mappings
local keymap = vim.keymap.set
keymap("n", "<Leader>d", "<Nop>", { noremap = true, silent = true, desc = "Debug menu" })
keymap("n", "<Leader>dm", runMain, { noremap = true, silent = true, desc = "Run main" })
keymap("n", "<Leader>db", runBuffer, { noremap = true, silent = true, desc = "Run current buffer" })
keymap("n", "<Leader>ds", sourceEnv, { noremap = true, silent = true, desc = "Source environment" })
