return {
	"L3MON4D3/LuaSnip",
	config = function()
		local ls = require("luasnip")

		ls.config.setup({ enable_autosnippets = true })

		vim.keymap.set({ "i", "s" }, "<A-Tab>", function()
			if ls.expand_or_jumpable() then
				return "<Plug>luasnip-expand-or-jump"
			end
		end, { expr = true, silent = true })
	end,
}
