return {
	"stevearc/conform.nvim",
	config = function()
		require("conform").setup({
			-- Map of filetype to formatters
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff", "black" },
				xml = { "xmlformatter" },
				markdown = { "doctoc" },
				["_"] = { "trim_whitespace" },
			},

			formatters = {
				prettier = { command = false },
				black = {
					prepend_args = { "--line-length", "1000" },
				},
				xmlformatter = {
					command = "/home/rok/.local/share/nvim/mason/bin/xmlformat",
					args = { "--indent", "2", "--blanks", "-" },
					stdin = true,
				},
				-- Add this to the markdown file where you want the TOC to be generated
				-- <!-- START doctoc -->
				-- <!-- END doctoc -->
				doctoc = {
					command = "doctoc",
					args = { "$FILENAME", "--update-only", "--maxlevel", "3" },
				},
			},

			default_format_opts = {
				lsp_format = "fallback",
			},

			format_on_save = {
				lsp_format = "fallback",
				timeout_ms = 500,
			},

			format_after_save = {
				lsp_format = "fallback",
			},

			log_level = vim.log.levels.DEBUG,
			notify_on_error = true,
			notify_no_formatters = true,
		})
	end,
}
