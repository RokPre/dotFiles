-- Colorscheme
vim.opt.background = "dark"

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		vim.schedule(function()
			local bg = "#1a1b26"
			local bg_dark = "#16161e"

			local fg = "#c0caf5"
			local fg_dark = "#a9b1d6"

			local comment = "#656e94"

			local orange = "#ff9e64"
			local orange_dim = "#d8a78b"
			local selection = "#283457"

			-- Small changes
			-- Use :hi command to view the color goups.
			vim.api.nvim_set_hl(0, "LineNr", { fg = orange })
			vim.api.nvim_set_hl(0, "CursorLineNr", { fg = orange })
			vim.api.nvim_set_hl(0, "LineNrAbove", { fg = orange_dim })
			vim.api.nvim_set_hl(0, "LineNrBelow", { fg = orange_dim })

			vim.api.nvim_set_hl(0, "UfoFoldedBg", { bg = selection })
			vim.api.nvim_set_hl(0, "Folded", { bg = selection })

			local ok, _ = pcall(require, "bufferline")
			if ok then
				vim.api.nvim_set_hl(0, "BufferLineFill", { bg = bg_dark })
				vim.api.nvim_set_hl(0, "BufferLineBackground", { fg = fg_dark, bg = bg_dark })
				vim.api.nvim_set_hl(0, "BufferLineBufferSelected", { fg = orange, bg = bg })
				vim.api.nvim_set_hl(0, "BufferLineBufferVisible", { fg = orange_dim, bg = bg })

				vim.api.nvim_set_hl(0, "BufferLineSeparator", { fg = bg_dark, bg = bg_dark })
				vim.api.nvim_set_hl(0, "BufferLineSeparatorSelected", { fg = bg_dark, bg = bg })
				vim.api.nvim_set_hl(0, "BufferLineSeparatorVisible", { fg = bg_dark, bg = bg })

				vim.api.nvim_set_hl(0, "BufferLineDuplicate", { fg = fg, bg = bg })
				vim.api.nvim_set_hl(0, "BufferLineDuplicateSelected", { fg = orange, bg = bg })
				vim.api.nvim_set_hl(0, "BufferLineDuplicateVisible", { fg = fg, bg = bg })
			end
			vim.api.nvim_set_hl(0, "Comment", { fg = comment })
		end)
	end,
})

local tn_ok, _ = pcall(require, "tokyonight")
if tn_ok then
	vim.cmd("colorscheme tokyonight-night")
end
