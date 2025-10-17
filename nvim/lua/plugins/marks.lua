local keymap = vim.keymap.set
local opts = { silent = true, noremap = true }

-- Marks
local function delete_mark_on_current_line()
	local current_line = vim.fn.line(".")
	local marks = "abcdefghijklmnopqrstuvwxyz123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789" -- Local marks to check
	local change = false

	for mark in marks:gmatch(".") do
		local pos = vim.fn.getpos("'" .. mark) -- Get the position of the mark
		if pos[2] == current_line then -- Check if the mark is on the current line
			vim.cmd("delmarks " .. mark)
			change = true
		end
	end
	if change then
		vim.cmd("redraw!")
	else
		vim.notify("No marks found on current line")
	end
end

local function auto_add_marks(searchWord, mark)
	vim.api.nvim_create_autocmd("BufReadPost", {
		pattern = "*",
		callback = function()
			for i = 1, vim.fn.line("$") do
				local line = vim.fn.getline(i)
				if
					line:match("function%s+" .. searchWord)
					or line:match("def%s+" .. searchWord)
					or line:match("int%s+" .. searchWord)
				then
					vim.cmd(i .. "mark " .. mark)
					break
				end
			end
		end,
	})
end

auto_add_marks("main", "m")
auto_add_marks("init", "i")

keymap("n", "m", "`", opts)
keymap("v", "m", "`", opts)
keymap("n", "<C-m>", "m", opts)
keymap("n", "dm", delete_mark_on_current_line, opts)
keymap("n", "<Leader>m", ":Telescope marks<CR>", opts)

return {
	"chentoast/marks.nvim",
	event = "VeryLazy",
	opts = {},
	config = function()
		require("marks").setup({
			default_mappings = false,
		})
	end,
}
