return {
  'stevearc/aerial.nvim',
  -- Optional dependencies
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons"
  },
  config = function()
    require("aerial").setup({
      attach_mode = "global",
      backends = { "lsp", "treesitter", "markdown", "man" },
      show_guides = true,
      close_automatic_events = { "unsupported", "unfocus", "switch_buffer" },
      close_on_select = true,
      autojump = true,
      highlight_on_jump = 500,
      -- open_automatic = true,
      layout = {
        min_width = 0.1,
        resize_to_content = true,
        default_direction = "prefer_left",
        win_opts = {
          winhl = "Normal:NormalFloat,FloatBorder:NormalFloat,SignColumn:SignColumnSB",
          signcolumn = "yes",
          statuscolumn = " ",
        },
      },
      guides = {
        mid_item   = "├╴",
        last_item  = "└╴",
        nested_top = "│ ",
        whitespace = "  ",
      },
      icons = {
        Class         = "󰠱", -- nf-md-alpha_c_circle
        Constructor   = "󰙅", -- nf-md-alpha_c_box (or ⌘ if you prefer)
        Enum          = "󰒻", -- nf-md-alpha_e_circle
        EnumMember    = "󰒻", -- same as Enum
        Event         = "󱐋", -- nf-md-alpha_e_box (or ⚡)
        -- Field         = "󰜢", -- nf-md-alpha_f_circle_outline
        File          = "󰈔", -- nf-md-file
        Function      = "󰊕", -- nf-md-function
        Interface     = "󰜰", -- nf-md-alpha_i_circle
        Method        = "󰆧", -- nf-md-alpha_m_circle
        Module        = "󰕳", -- nf-md-alpha_m_box
        Namespace     = "󰌗", -- nf-md-alpha_n_circle
        Package       = "󰏗", -- nf-md-package
        Property      = "󰓹", -- nf-md-alpha_p_circle
        Struct        = "󰙅", -- nf-md-alpha_s_circle
        -- Variable      = "󰫧", -- nf-md-alpha_v_circle
        Constant      = "󰏿", -- nf-md-alpha_c_box
        -- String        = "󰉿", -- nf-md-alpha_s_box
        -- Number        = "󰎠", -- nf-md-numeric
        -- Boolean       = "󰔯", -- nf-md-alpha_b_circle
        -- Key           = "󰌆", -- nf-md-key
        -- Null          = "󰟢", -- nf-md-null
        Object        = "󰅩", -- nf-md-cube
        TypeParameter = "󰊄", -- nf-md-alpha_t_circle
        Collapsed     = "", -- triangle for collapsed nodes
      },
      filter_kind = {
        "Class",
        "Constructor",
        "Enum",
        "EnumMember",
        "Event",
        -- "Field",
        "File",
        "Function",
        "Interface",
        "Method",
        "Module",
        "Namespace",
        "Package",
        "Property",
        "Struct",
        -- "Variable",
        "Constant",
        -- "String",
        -- "Number",
        -- "Boolean",
        -- "Key",
        -- "Null",
        "Object",
        "TypeParameter",
        "Collapsed",
      },
      get_highlight = function()
        vim.api.nvim_set_hl(0, "AerialLine", { fg = "None", bg = "#283457", bold = true })
      end,
    })
    vim.keymap.set("n", "<leader>a", "<Nop>", { desc = "Aerial" })
    vim.keymap.set("n", "<leader>aa", "<cmd>AerialOpen left<cr>", { desc = "Open aerial" })
    vim.keymap.set("n", "<leader>al", "<cmd>AerialClose<cr><cmd>AerialOpen left<cr>", { desc = "Open left" })
    vim.keymap.set("n", "<leader>ar", "<cmd>AerialClose<cr><cmd>AerialOpen right<cr>", { desc = "Open right" })
    vim.keymap.set("n", "<leader>ac", "<cmd>AerialClose<cr>", { desc = "Close aerial" })
    vim.keymap.set("n", "<leader>an", "<cmd>AerialNavToggle<cr>", { desc = "Toggle aerial" })

    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        vim.cmd("AerialClose")
      end,
    })
  end
}
