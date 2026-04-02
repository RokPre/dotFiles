return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	build = "cd app && npm install",
	init = function()
		vim.g.mkdp_filetypes = { "markdown" }
		vim.g.mkdp_images_path = "/home/rok/sync/knowledgeVault"
		vim.g.mkdp_markdown_css = "/home/rok/sync/dotFiles/nvim/lua/plugins/markdownPreview.css"
		vim.g.mkdp_auto_close = 0
		vim.g.mkdp_combine_preview = 0
	end,
	ft = { "markdown" },
}
