-- Make sure this runs *after* vim-vsnip is loaded:
vim.api.nvim_create_autocmd("User", {
	pattern = "VimEnter",
	callback = function()
		local keymap = vim.keymap.set

		-- <Tab> to expand or jump forward
		keymap({ "i", "s" }, "<Tab>", function()
			if vim.fn == 1 then
				return "<Plug>(vsnip-expand-or-jump)"
			else
				return "<Tab>"
			end
		end, { expr = true, silent = true })

		-- <S-Tab> to jump backward
		keymap({ "i", "s" }, "<S-Tab>", "<Plug>(vsnip-jump-prev)", { silent = true })
	end,
})

-- in your Lazy plugins spec file (e.g. lua/plugins/vsnip.lua)
return {
	{
		"hrsh7th/vim-vsnip",
		-- load before any completion integrations
		dependencies = { "hrsh7th/vim-vsnip-integ" },
		config = function()
			-- 1) Tell vim-vsnip where your snippet JSON lives:
			vim.g.vsnip_snippet_dir = vim.fn.expand("~/sync/dotFiles/nvim/vsnippets")

			-- 2) Map <Tab> to expand or jump, <S-Tab> to jump backwards
			local keymap = vim.keymap.set
			keymap({ "i", "s" }, "<Tab>", function()
				if vim.fn == 1 then
					return "<Plug>(vsnip-expand-or-jump)"
				else
					return "<Tab>"
				end
			end, { expr = true, silent = true })

			keymap({ "i", "s" }, "<S-Tab>", "<Plug>(vsnip-jump-prev)", { silent = true })
		end,
	},
	{
		"hrsh7th/vim-vsnip-integ",
		-- no extra config needed here unless you integrate with nvim-cmp etc.
	},
}
