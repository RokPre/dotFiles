vim.o.guifont = "Cousine Nerd Font Mono:h12" -- text below applies for VimScript
-- vim.o.guifont = "Agave Nerd Font Mono:h11"
-- vim.o.guifont = "JetBrainsMono Nerd Font Mono:h14"

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    vim.defer_fn(function()
      -- Your code here, e.g., setting Neovide scale factor
      vim.g.neovide_scale_factor = 1
    end, 120) -- Delay in milliseconds
  end,
})

vim.keymap.set("n", "<C-->", function()
  local scale_factor = vim.g.neovide_scale_factor
  scale_factor = scale_factor - 0.1
  vim.g.neovide_scale_factor = scale_factor
end)

vim.keymap.set("n", "<C-+>", function()
  local scale_factor = vim.g.neovide_scale_factor
  scale_factor = scale_factor + 0.1
  vim.g.neovide_scale_factor = scale_factor
end)
