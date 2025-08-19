return {
  "lervag/vimtex",
  lazy = false, -- load at startup; or use event = "BufReadPre *.tex" if you prefer
  init = function()
    -- Viewer and compiler
    vim.g.vimtex_view_method = "zathura" -- use 'zathura_simple' on Wayland
    vim.g.vimtex_view_use_temp_files = 0
    vim.g.vimtex_quickfix_mode = 0
  end,
}
