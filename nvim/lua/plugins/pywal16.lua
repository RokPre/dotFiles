return {
  'uZer/pywal16.nvim',
  config = function()
    local ok = pcall(function()
      local home = os.getenv("HOME")
      local json_string = table.concat(vim.fn.readfile(home .. "/.cache/wal/colors.json"), "\n")
      local colors = vim.fn.json_decode(json_string)
      -- Load colorscheme first, then override background
      vim.cmd.colorscheme("pywal16")

      -- Delay highlight override to ensure it's not overwritten
      vim.defer_fn(function()
        vim.cmd("highlight Normal guibg=" .. colors.special.background)
        vim.api.nvim_set_hl(0, "NotifyBackground", { bg = colors.special.background })
      end, 100)
    end)
    if not ok then
      vim.cmd.colorscheme("tokyonight-night")
    end
  end,
}
