return {
	"github/copilot.vim",
	event = "VeryLazy",
	config = function()
		vim.g.copilot_no_tab_map = true
		vim.api.nvim_set_keymap("i", "<C-a>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
		vim.api.nvim_set_keymap("i", "<C-q>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
		local comment = "#656e94"
		vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = comment })
	end,
}
