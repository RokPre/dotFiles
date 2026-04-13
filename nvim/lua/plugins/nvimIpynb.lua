return {
	"zchown/nvim-ipynb",
	ft = { "ipynb", "python" },
	config = function()
		vim.env.PATH = vim.fn.expand("~/.local/bin") .. ":" .. vim.env.PATH
		require("ipynb").setup()
	end,
}
