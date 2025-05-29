return {
  "hrsh7th/nvim-cmp",
  version = false, -- last release is way too old
  event = "InsertEnter",
  dependencies = {
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-emoji",
    "hrsh7th/cmp-calc",
    "chrisgrieser/cmp-nerdfont",
    "saadparwaiz1/cmp_luasnip",
  },

  config = function()
    vim.diagnostic.config({
      signs = false,
    })
    local cmp = require("cmp")
    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<Esc>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = false }), -- false: accepts only the currently explicitly selected item
      }),

      sources = cmp.config.sources({
        -- { name = "supermaven" },
        { name = "buffer" },
        { name = "calc" },
        { name = "cmdline" },
        { name = "emoji" },
        { name = "luasnip" },
        { name = "nerdfont" },
        { name = "nvim_lsp" },
        { name = "nvim_lsp:lua_ls" },
        { name = "obsidian" },
        { name = "obsidian_new" },
        { name = "obsidian_tags" },
        { name = "path" },
      }, {
        { name = "buffer" },
      }),
    })

    -- Set up lspconfig capabilities
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- Set up your language servers here
    local lspconfig = require("lspconfig")
    lspconfig.pyright.setup({
      capabilities = capabilities,
    })
    lspconfig.matlab_ls.setup({
      capabilities = capabilities,
    })

    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = {
            -- tell the server you're using LuaJIT
            version = 'LuaJIT',
          },
          diagnostics = {
            -- recognize the vim and require globals
            globals = { 'vim', 'require' },
          },
          workspace = {
            -- make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
          },
          telemetry = {
            enable = false,
          },
        },
      },
    })
  end,
}
