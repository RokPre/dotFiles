local version = vim.version()

-- if version.major > 0 or (version.major == 0 and version.minor >= 11) then
if version.major > 0 or (version.major == 0 and version.minor > 11) then
  vim.lsp.config["stylua"] = {    
    cmd = {"stylua", "--lsp"},   
    filetypes = {"lua"}
  }
  vim.lsp.enable("stylua")

  vim.lsp.config["pyrefly"] = {
    cmd = {"pyrefly", "lsp"},
    filetypes = {"python"}
  }
  vim.lsp.enable("pyrefly")   

  return {}
else
  return {
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig").lua_ls.setup({})
      require("lspconfig").pyrefly.setup({})
    end
  }
end
