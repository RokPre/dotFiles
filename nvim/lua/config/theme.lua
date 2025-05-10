-- Colors
-- vim.cmd([[colorscheme onedark]])
vim.cmd([[colorscheme tokyonight-moon]])
vim.cmd("hi CursorLineNr guifg=#ff966c")
vim.cmd("hi LineNr guifg=#ff966c")
vim.cmd("hi LineNrAbove guifg=#a66f59")
vim.cmd("hi LineNrBelow guifg=#a66f59")
vim.opt.fillchars = { eob = " " }

-- TODO: Add a function that removes the base of the variants from the list. For example remove tokyonight, as it has tokyonight-moon, tokyonight-day, tokyonight-storm, tokyonight-nigh 

_G.colorschemes = {}
_G.currnet_theme_index = 1
local function get_all_color_themes()
  local all_themes = vim.fn.getcompletion("", "color")
  for _, theme_with_variant in ipairs(all_themes) do
    local has_variant = false
    for _, theme in ipairs(all_themes) do
      if theme ~= theme_with_variant and theme:find(theme_with_variant) then
       has_variant = true
      end
    end
    if not has_variant then
      table.insert(_G.colorschemes, theme_with_variant)
    end
  end
end

local function next_color_theme()
  _G.currnet_theme_index = _G.currnet_theme_index + 1
  if _G.currnet_theme_index > #_G.colorschemes then
    _G.currnet_theme_index = 1
  end
  vim.cmd('colorscheme default')
  vim.cmd("colorscheme " .. _G.colorschemes[_G.currnet_theme_index])
  vim.print("Set theme to: ".. _G.colorschemes[_G.currnet_theme_index])
end

local function previous_color_theme()
  _G.currnet_theme_index = _G.currnet_theme_index - 1
  if _G.currnet_theme_index < 1 then
    _G.currnet_theme_index = #_G.colorschemes
  end
  vim.cmd('colorscheme default')
  vim.cmd("colorscheme " .. _G.colorschemes[_G.currnet_theme_index])
  vim.print("Set theme to: ".. _G.colorschemes[_G.currnet_theme_index])
end

local function delete_color_theme()
  _G.currnet_theme_index = _G.currnet_theme_index
  local index = _G.currnet_theme_index - 1
  if index < 1 then
    index = #_G.colorschemes
  end
  vim.cmd('colorscheme default')
  vim.cmd('colorscheme ' .. _G.colorschemes[index])
  vim.print("Removed: " .. _G.colorschemes[_G.currnet_theme_index])
  table.remove(_G.colorschemes, _G.currnet_theme_index)
  _G.currnet_theme_index = index
end

get_all_color_themes()
-- vim.print(_G.colorschemes)

-- Keymaps
-- vim.keymap.set("n", "<leader>cn", next_color_theme, { noremap = true, silent = true })
-- vim.keymap.set("n", "<leader>cp", previous_color_theme, { noremap = true, silent = true })
-- vim.keymap.set("n", "<leader>cd", delete_color_theme, { noremap = true, silent = true })
-- vim.keymap.set("n", "<leader>cg", get_all_color_themes, { noremap = true, silent = true })
