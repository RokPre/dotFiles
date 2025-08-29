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
    -- 1) Default: non-focusable hover (for auto popups)
    local default_hover = vim.lsp.with(vim.lsp.handlers.hover, {
      focusable = false,
      border = "rounded",
      close_events = { "CursorMoved", "BufHidden", "InsertLeave" },
    })
    vim.lsp.handlers["textDocument/hover"] = default_hover

    -- 2) Auto hover on CursorHold (uses non-focusable handler above)
    vim.o.updatetime = 1000
    vim.api.nvim_create_autocmd("CursorHold", {
      callback = function()
        silent_hover()
        -- vim.lsp.buf.hover()
      end,
    })

    function _G.silent_hover()
      local params = vim.lsp.util.make_position_params()
      vim.lsp.buf_request(0, "textDocument/hover", params, function(err, result, ctx, config)
        if err
            or not result
            or not result.contents
            or (type(result.contents) == "table" and vim.tbl_isempty(result.contents))
        then
          return -- nothing to show
        end
        vim.lsp.handlers.hover(err, result, ctx, config)
      end)
    end

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
        -- ["<Esc>"] = cmp.mapping.abort(),
        ["<C-c>"] = cmp.mapping.abort(),
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
    -- lspconfig.pyright.setup({
    --   capabilities = capabilities,
    -- })
    lspconfig.basedpyright.setup({
      settings = {
        basedpyright = {
          analysis = {
            typeCheckingMode = "basic", -- or "strict"
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
          },
        },
      },
    })

    lspconfig.matlab_ls.setup({
      capabilities = capabilities,
    })

    -- lspconfig.ltex_plus.setup({
    --   settings = {
    --     ltex = {
    --       language = "sl-SI",
    --     },
    --   },
    -- })
    lspconfig.texlab.setup({})

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
