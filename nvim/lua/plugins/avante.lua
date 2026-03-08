return {
	"yetone/avante.nvim",
	event = "VeryLazy", -- Load only when needed, not at startup
	version = false,

	dependencies = {
		"nvim-tree/nvim-web-devicons", -- File icons
		"stevearc/dressing.nvim", -- Better UI inputs
		"nvim-lua/plenary.nvim", -- Utility functions
		"MunifTanjim/nui.nvim", -- UI components

		-- Optional but recommended
		"nvim-treesitter/nvim-treesitter", -- Better syntax understanding
	},

	opts = {
		provider = "codex",
		acp_providers = {
			["codex"] = {
				command = "npx",
				args = { "-y", "-g", "@zed-industries/codex-acp" },
			},
		},

		-- UI behavior
		behaviour = {
			auto_suggestions = false, -- Enable inline suggestions
			auto_set_highlight_group = true,
			auto_apply_diff_after_generation = false, -- Review before applying
		},

		-- What to send as context
		windows = {
			wrap = true, -- Wrap long lines in chat
			width = 40, -- Sidebar width (% of screen)
			sidebar_header = {
				align = "center",
				rounded = true,
			},
		},
	},
}
