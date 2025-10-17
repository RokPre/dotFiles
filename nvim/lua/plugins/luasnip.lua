return {
	"L3MON4D3/LuaSnip",
	config = function()
		local ls = require("luasnip")

		ls.config.set_config({ enable_autosnippets = true })

		vim.keymap.set({ "i", "s" }, "<Tab>", function()
			if ls.expand_or_jumpable() then
				return "<Plug>luasnip-expand-or-jump"
			else
				return "<Tab>"
			end
		end, { expr = true, silent = true })

		vim.keymap.set({ "i", "s" }, "<S-Tab>", "<Plug>luasnip-jump-prev", { silent = true })
	end,
}
