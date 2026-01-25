-- Lualine configuration
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        icons_enabled = true,
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        theme = "auto",
      },
      tabline = {},
      sections = {
        lualine_a = { function()
          local msg = vim.fn.expand("%:p:h")
          local home = os.getenv("HOME")
          if not home then
            return "󰚌"
          end
          if msg:match("oil%-ssh://") then
            return "󰛳"
          elseif msg:match("oil") then
            return ""
          elseif msg:match(home) then
            return "󰋞"
          else
            return ""
          end
        end, "data" },
        lualine_b = { function()
          local home = os.getenv("HOME")
          local msg = vim.fn.expand("%:p:h")
          if msg:match("oil://") then
            return msg:gsub("oil://", "")
          elseif msg:match("oil%-ssh://") then
            return msg:gsub("oil%-ssh://", "")
          elseif home and msg:match(home) then
            return msg:gsub(home, "")
          elseif msg == "oil:" then
            return "/"
          else
            return vim.fn.expand("%:p:h")
          end
        end
        , "data"
        },
        lualine_c = { function()
          return vim.fn.expand("%:p:t")
        end, "data" },
        lualine_x = { "diff" },
        lualine_y = { "branch" },
        lualine_z = {
          function()
            local time = os.date("*t")
            local hour = time.hour
            local minute = time.min

            local Hours = { "Midnight", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven", "Noon", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven" }

            local phrases = {
              [0] = string.format("%s o'clock", Hours[hour + 1]),
              [1] = string.format("Quarter past %s", string.lower(Hours[hour + 1])),
              [2] = string.format("Half past %s", string.lower(Hours[hour + 1])),
              [3] = string.format("Quarter to %s", string.lower(Hours[hour + 2])),
              [4] = string.format("%s o'clock", Hours[hour + 2]),
            }

            local minute_index = math.floor((minute + 7.5) / 15) -- Round to nearest quarter
            return phrases[minute_index]                         -- quarter past, half past, quarter to
          end,
          "data",
        },
      },
      extensions = { "quickfix", "fugitive", "nvim-tree" },
    })
  end,
}
