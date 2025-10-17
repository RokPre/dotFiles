-- Colorscheme
vim.opt.background = "dark"

local function adjust_oklch(hex, opts)
  opts = opts or {}
  local function hex_to_rgb(h)
    h = h:gsub("#", "")
    return tonumber(h:sub(1, 2), 16) / 255,
        tonumber(h:sub(3, 4), 16) / 255,
        tonumber(h:sub(5, 6), 16) / 255
  end
  local function rgb_to_hex(r, g, b)
    return string.format("#%02x%02x%02x",
      math.floor(math.max(0, math.min(1, r)) * 255 + 0.5),
      math.floor(math.max(0, math.min(1, g)) * 255 + 0.5),
      math.floor(math.max(0, math.min(1, b)) * 255 + 0.5))
  end

  local r, g, b = hex_to_rgb(hex)

  -- sRGB -> OKLab
  local l = 0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b
  local m = 0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b
  local s = 0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b
  l, m, s = l ^ (1 / 3), m ^ (1 / 3), s ^ (1 / 3)
  local L = 0.2104542553 * l + 0.7936177850 * m - 0.0040720468 * s
  local A = 1.9779984951 * l - 2.4285922050 * m + 0.4505937099 * s
  local B = 0.0259040371 * l + 0.7827717662 * m - 0.8086757660 * s

  -- OKLab -> OKLCH
  local C = math.sqrt(A * A + B * B)
  local H = math.deg(math.atan2(B, A)) % 360

  -- apply deltas
  local L2 = math.min(math.max(L + (opts.dL or 0), 0), 1)
  local C2 = math.max(C + (opts.dC or 0), 0)
  local H2 = (H + (opts.dH or 0)) % 360

  -- OKLCH -> OKLab
  local A2 = math.cos(math.rad(H2)) * C2
  local B2 = math.sin(math.rad(H2)) * C2

  -- OKLab -> sRGB
  local l2 = (L2 + 0.3963377774 * A2 + 0.2158037573 * B2) ^ 3
  local m2 = (L2 - 0.1055613458 * A2 - 0.0638541728 * B2) ^ 3
  local s2 = (L2 - 0.0894841775 * A2 - 1.2914855480 * B2) ^ 3
  local R = 4.0767416621 * l2 - 3.3077115913 * m2 + 0.2309699292 * s2
  local G = -1.2684380046 * l2 + 2.6097574011 * m2 - 0.3413193965 * s2
  local Bf = -0.0041960863 * l2 - 0.7034186147 * m2 + 1.7076147010 * s2

  return rgb_to_hex(R, G, Bf)
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.schedule(function()
      local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
      -- local normal_dark = vim.api.nvim_get_hl(0, { name = "NormalFloat" })
      local normal_dark = {
        -- fg = adjust_oklch(string.format("#%06x", normal_dark.fg), { dL = -0.1 }),
        bg = adjust_oklch(string.format("#%06x", normal.bg), { dL = -0.08 })
      }
      local normal_dark_dark = {
        -- fg = adjust_oklch(string.format("#%06x", normal_dark.fg), { dL = -0.1 }),
        bg = adjust_oklch(normal_dark.bg, { dL = -0.08 })
      }

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

      local ok, bufferline = pcall(require, "bufferline")
      if ok then
        vim.api.nvim_set_hl(0, "BufferLineFill", { bg = normal_dark_dark.bg })
        vim.api.nvim_set_hl(0, "BufferLineBackground", { fg = normal.fg, bg = normal_dark.bg })
        vim.api.nvim_set_hl(0, "BufferLineBufferSelected", { fg = highlight, bg = normal.bg })

        vim.api.nvim_set_hl(0, "BufferLineDevIconDefault", { fg = normal.fg, bg = normal_dark.bg })
        vim.api.nvim_set_hl(0, "BufferLineDevIconLua", { fg = normal.fg, bg = normal_dark.bg })
        vim.api.nvim_set_hl(0, "BufferLineDevIconMd", { fg = normal.fg, bg = normal_dark.bg })
        vim.api.nvim_set_hl(0, "BufferLineDevIconLuaSelected", { fg = highlight, bg = normal.bg })

        vim.api.nvim_set_hl(0, "BufferLineSeparator", { fg = normal_dark_dark.bg, bg = normal_dark.bg })
        vim.api.nvim_set_hl(0, "BufferLineSeparatorSelected", { fg = normal_dark_dark.bg, bg = normal.bg })

        vim.api.nvim_set_hl(0, "BufferLineDuplicate", { fg = normal.fg, bg = normal.bg })
        vim.api.nvim_set_hl(0, "BufferLineDuplicateSelected", { fg = normal.fg, bg = normal.bg })
        vim.api.nvim_set_hl(0, "BufferLineDuplicateVisible", { fg = normal.fg, bg = normal.bg })

        vim.api.nvim_set_hl(0, "BufferLineTab", { fg = normal.fg, bg = normal_dark.bg })
        vim.api.nvim_set_hl(0, "BufferLineTabSelected", { fg = highlight, bg = normal.bg })
        vim.api.nvim_set_hl(0, "BufferLineTabSeparator", { fg = normal_dark_dark.bg, bg = normal_dark.bg })
        vim.api.nvim_set_hl(0, "BufferLineTabSeparatorSelected", { fg = normal_dark_dark.bg, bg = normal.bg })
      end
    end)
  end
})

vim.cmd("colorscheme tokyonight")
