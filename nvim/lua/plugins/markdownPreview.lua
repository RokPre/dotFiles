return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && npm install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
    vim.g.mkdp_images_path = "/home/rok/sync/knowledgeVault/Attachment folder/Excalidraw"
    vim.g.mkdp_markdown_css = "/home/rok/sync/dotFiles/nvim/lua/plugins/markdownPreview.css"
  end,
  ft = { "markdown" },
}
