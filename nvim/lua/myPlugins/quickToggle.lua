local keymap = vim.keymap.set
local opts = { silent = true, noremap = true }

local quickToggle = function()
  local word = vim.fn.expand("<cword>")

  local word_map = {
    ["True"] = "False",
    ["False"] = "True",
    ["true"] = "false",
    ["false"] = "true",
  }

  if word_map[word] then
    vim.cmd("normal! ciw" .. word_map[word])
    return
  end

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.fn.getline(row)
  local char = line:sub(col + 1, col + 1) -- +1 because Lua is 1-based

  local char_map = {
    ["+"] = "-",
    ["-"] = "+",
    ["*"] = "/",
    ["/"] = "*",
    ["="] = ":",
    [":"] = "=",
    [">"] = "<",
    ["<"] = ">",
    ["("] = ")",
    [")"] = "(",
    ["["] = "]",
    ["]"] = "[",
    ["{"] = "}",
    ["}"] = "{",
  }

  if char_map[char] then
    vim.cmd("normal! r" .. char_map[char])
    return
  end

  -- fallback: swap case
  vim.cmd("normal! ~")
end

keymap("n", "<C-u>", quickToggle, opts)
