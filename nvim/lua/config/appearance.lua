vim.opt.background = "dark"

M = {
	bg = "#1a1b26",
	bg_dark = "#16161e",
	bg_darker = "#0C0E14",
	bg_highlight = "#292e42",

	fg = "#c0caf5",
	fg_dark = "#a9b1d6",
	fg_darker = "#858db0",
	fg_lighter = "#d1dcff",
	fg_gutter = "#3b4261",

	selection = "#283457",

	blue = "#7aa2f7",
	cyan = "#7dcfff",
	green = "#9ece6a",
	yellow = "#e0af68",
	orange = "#ff9e64",
	red = "#f7768e",
	magenta = "#bb9af7",
	purple = "#9d7cd8",
	comment = "#656e94",

	bg_lighter = "#20212c",

	blue_light = "#9fc3ff",
	cyan_light = "#b8edff",
	green_light = "#beef8a",
	yellow_light = "#ffcf88",
	orange_light = "#ffc9a3",
	red_light = "#ffa2b2",
	magenta_light = "#d9beff",
	purple_light = "#bc9bfa",

	blue_dark = "#5d83d5",
	cyan_dark = "#5dafdd",
	green_dark = "#80ae4a",
	yellow_dark = "#bf9049",
	orange_dark = "#dd7f44",
	red_dark = "#d45670",
	magenta_dark = "#9c7bd5",
	purple_dark = "#7f5eb7",

	blue_dull = "#9aadd8",
	cyan_dull = "#9dc7de",
	green_dull = "#9db583",
	yellow_dull = "#c2aa86",
	orange_dull = "#d8a78b",
	red_dull = "#fb728b",
	magenta_dull = "#c1b1e0",
	purple_dull = "#a493c1",
}

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		vim.print("test")
		vim.api.nvim_set_hl(0, "LineNr", { fg = M.orange })
		vim.api.nvim_set_hl(0, "CursorLineNr", { fg = M.orange })
		vim.api.nvim_set_hl(0, "LineNrAbove", { fg = M.orange_dull })
		vim.api.nvim_set_hl(0, "LineNrBelow", { fg = M.orange_dull })

		vim.api.nvim_set_hl(0, "UfoFoldedBg", { bg = M.selection })
		vim.api.nvim_set_hl(0, "Folded", { bg = M.selection })
		vim.api.nvim_set_hl(0, "Comment", { fg = M.comment })
	end,
})

local ok, _ = pcall(require, "tokyonight")
if ok then
	vim.cmd("colorscheme tokyonight-night")
end

return M
