return {
	"epwalsh/obsidian.nvim",
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		workspaces = {
			{
				name = "vault",
				path = "~/sync/vault",
			},
		},
		disable_frontmatter = true,
		templates = {
			folder = "template",
			date_format = "%Y - %j",
			time_format = "%H:%M",
			substitutions = {
				today = function()
					return os.date("%Y %B %d - %A")
				end,
				yesterday = function()
					return os.date("%Y - %j", os.time() - 86400)
				end,
				tomorrow = function()
					return os.date("%Y - %j", os.time() + 86400)
				end,
				day = function()
					return os.date("%A")
				end,
				id = function()
					return os.time(os.date("!*t")) -- not unix timestamp
				end,
			},
		},
		daily_notes = {
			folder = "Dnevnik",
			date_format = "%Y - %j",
			template = "Neovim-DailyNote-template.md",
		},
		completion = {
			nvim_cmp = true,
			min_chars = 2,
		},
		ui = {
			enable = false,
		},
	},
}
