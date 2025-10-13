-- Colorscheme
vim.opt.background = "dark"
vim.cmd("colorscheme tokyonight-night")

local highlight = "#ff966c"
local highlight_dim = "#a66f59"
local selection = "#283457"

-- Small changes
vim.api.nvim_set_hl(0, "LineNr", { fg = highlight })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = highlight })
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = highlight_dim })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = highlight_dim })

vim.api.nvim_set_hl(0, "UfoFoldedBg", { bg = selection })
vim.api.nvim_set_hl(0, "Folded", { bg = selection })


local function to_hex(n)
  if not n then return nil end
  local b = n % 256
  local g = math.floor(n / 256) % 256
  local r = math.floor(n / 65536) % 256
  return string.format("#%02x%02x%02x", r, g, b)
end
