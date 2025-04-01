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

keymap("n", "m", "`", opts)
keymap("v", "m", "`", opts)
keymap("n", "<C-m>", "m", opts)
keymap("n", "dm", delete_mark_on_current_line, opts)
keymap("n", "<Leader>m", ":Telescope marks<CR>", opts)
keymap("n", "<Leader>t", ":TodoTelescope<CR>", opts)

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
