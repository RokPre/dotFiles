-- TODO: Make this compatible with folders as well.
local keymap = vim.keymap.set

local file_path_to_paste = nil

local function copy_file_path()
  file_path_to_paste = vim.api.nvim_buf_get_name(0)
  file_path_to_paste = file_path_to_paste:gsub(os.getenv("HOME"), "~")
  vim.fn.setreg("+", file_path_to_paste)
  vim.fn.setreg('"', file_path_to_paste)
end

local function paste_absolute_path()
  if not file_path_to_paste or file_path_to_paste == "" then
    vim.notify("No file path to paste")
    return
  end
  vim.api.nvim_buf_set_lines(
  vim.api.nvim_get_current_buf(),
  vim.api.nvim_win_get_cursor(0)[1] - 1,
  vim.api.nvim_win_get_cursor(0)[1],
  false,
  file_path_to_paste
  )
end

local function paste_markdown_link(embed)
  if not file_path_to_paste or file_path_to_paste == "" then
    vim.notify("No file path to paste")
    return
  end

  local current_file_path = vim.api.nvim_buf_get_name(0)
  local parent_folder = vim.fn.fnamemodify(current_file_path, ":p:h")
  local abs_file_path_to_paste = vim.fn.fnamemodify(file_path_to_paste, ":p")
  local found = nil
  local relative_file_path = ""

  while parent_folder ~= "/" and parent_folder ~= "" do
    if vim.startswith(abs_file_path_to_paste, parent_folder) then
      found = parent_folder
      break
    end
    parent_folder = vim.fn.fnamemodify(parent_folder, ":h")
    relative_file_path = relative_file_path .. "../"
  end

  -- Get properties from file
  local lines = vim.fn.readfile(abs_file_path_to_paste)
  local in_properties = false
  local properties_lines = {}
  for _, line in ipairs(lines) do
    if line:match("^%-%-%-$") then
      if in_properties then
        break -- Break at the end of the properties
      else
        in_properties = true -- start after opening ---
      end
    elseif in_properties then
      properties_lines[#properties_lines + 1] = line
    end
  end

  -- Get aliases from properties
  local file_name = vim.fn.fnamemodify(file_path_to_paste, ":t:r")
  local aliases = { file_name }
  local in_aliases = false
  for _, line in ipairs(properties_lines) do
    if line:match("^aliases:") or line:match("^alias:") then
      in_aliases = true
    elseif in_aliases then
      local alias = line:match("^%s*%-%s*(.+)")
      if alias then
        table.insert(aliases, alias)
      elseif line:match("^%w+:") then
        -- next property starts, stop reading aliases
        in_aliases = false
      end
    end
  end

  -- Chose the alias if it exists
  local link_name = file_name
  if #aliases > 1 then
    vim.ui.select(aliases, {
      prompt = "Select alias",
      format_item = function(alias)
        return alias
      end,
    }, function(choice)
      if choice then
        link_name = choice
        if found then
          local rel = abs_file_path_to_paste:sub(#found + 2) -- Removes the folders from the aboslue path that are the same from the current file path.
          -- The ../.. navigate to the first common folder. Then we have to remove any folder that is above the first common folder. the :sub function does this.
          -- Then we paste the the ... and the path from the first common folder togethter to get the relative path.
          relative_file_path = relative_file_path .. rel
          link = string.format("[%s](<%s>)", link_name, relative_file_path)
        else
          vim.notify("No common parent folder found. Pasting absolute path")
          link = string.format("[%s](<%s>)", link_name, file_path_to_paste)
        end

        if embed then
          link = "!" .. link
        end

        vim.api.nvim_buf_set_lines(
        vim.api.nvim_get_current_buf(),
        vim.api.nvim_win_get_cursor(0)[1] - 1,
        vim.api.nvim_win_get_cursor(0)[1],
        false,
        { link }
        )
      end
    end)

  else

    local link = ""
    if found then
      local rel = abs_file_path_to_paste:sub(#found + 2) -- Removes the folders from the aboslue path that are the same from the current file path.
      -- The ../.. navigate to the first common folder. Then we have to remove any folder that is above the first common folder. the :sub function does this.
      -- Then we paste the the ... and the path from the first common folder togethter to get the relative path.
      relative_file_path = relative_file_path .. rel
      link = string.format("[%s](<%s>)", link_name, relative_file_path)
    else
      vim.notify("No common parent folder found. Pasting absolute path")
      link = string.format("[%s](<%s>)", link_name, file_path_to_paste)
    end

    if embed then
      link = "!" .. link
    end

    vim.api.nvim_buf_set_lines(
    vim.api.nvim_get_current_buf(),
    vim.api.nvim_win_get_cursor(0)[1] - 1,
    vim.api.nvim_win_get_cursor(0)[1],
    false,
    { link }
    )
  end
end

local function embed_markdown_link()
  if not file_path_to_paste or file_path_to_paste == "" then
    vim.notify("No file path to paste")
    return
  end

  local file_name = vim.fn.fnamemodify(file_path_to_paste, ":t:r")
  local link = string.format("!(%s)[%s]", file_name, file_path_to_paste)

  vim.api.nvim_buf_set_lines(
  vim.api.nvim_get_current_buf(),
  vim.api.nvim_win_get_cursor(0)[1] - 1,
  vim.api.nvim_win_get_cursor(0)[1],
  false,
  { link }
  )
end

-- local function paste_obsidian_link()
  -- 	if not file_path_to_paste or file_path_to_paste == "" then
  -- 		vim.notify("No file path to paste")
  -- 		return
  -- 	end
  --
  -- 	local file_name = vim.fn.fnamemodify(file_path_to_paste, ":t:r")
  -- 	local link = string.format("[[%s]]", file_name)
  --
  -- 	vim.api.nvim_buf_set_lines(
  -- 		vim.api.nvim_get_current_buf(),
  -- 		vim.api.nvim_win_get_cursor(0)[1] - 1,
  -- 		vim.api.nvim_win_get_cursor(0)[1],
  -- 		false,
  -- 		{ link }
  -- 	)
  -- end
  --
  -- local function embed_obsidian_link()
    -- 	if not file_path_to_paste or file_path_to_paste == "" then
    -- 		vim.notify("No file path to paste")
    -- 		return
    -- 	end
    --
    -- 	local file_name = vim.fn.fnamemodify(file_path_to_paste, ":t:r")
    -- 	local link = string.format("![[%s]]", file_name)
    --
    -- 	vim.api.nvim_buf_set_lines(
    -- 		vim.api.nvim_get_current_buf(),
    -- 		vim.api.nvim_win_get_cursor(0)[1] - 1,
    -- 		vim.api.nvim_win_get_cursor(0)[1],
    -- 		false,
    -- 		{ link }
    -- 	)
    -- end

    local function paste_relative_path()
      if not file_path_to_paste or file_path_to_paste == "" then
        vim.notify("No file path to paste")
        return
      end

      local current_file_path = vim.api.nvim_buf_get_name(0)
      local parent_folder = vim.fn.fnamemodify(current_file_path, ":p:h")
      local abs_file_path_to_paste = vim.fn.fnamemodify(file_path_to_paste, ":p")

      -- vim.print("abs the file path", abs_file_path_to_paste)
      -- vim.print("current file path", current_file_path)

      -- climb upwards until we either find a parent inside abs_file_path_to_paste or reach root
      local found = nil
      local link = ""
      while parent_folder ~= "/" and parent_folder ~= "" do
        if vim.startswith(abs_file_path_to_paste, parent_folder) then
          found = parent_folder
          break
        end
        parent_folder = vim.fn.fnamemodify(parent_folder, ":h")
        link = link .. "../"
      end

      if found then
        -- now you could cut the common prefix and build a relative path
        local rel = abs_file_path_to_paste:sub(#found + 2) -- +2 to skip trailing "/"
        link = link .. rel
        -- vim.print("Relative part:", rel)
        -- vim.print("Relative part:", link)
      else
        vim.notify("No common parent folder found")
        -- Fallback to absolute path
        vim.api.nvim_buf_set_lines(
        vim.api.nvim_get_current_buf(),
        vim.api.nvim_win_get_cursor(0)[1] - 1,
        vim.api.nvim_win_get_cursor(0)[1],
        false,
        { abs_file_path_to_paste }
        )
        return
      end

      vim.api.nvim_buf_set_lines(
      vim.api.nvim_get_current_buf(),
      vim.api.nvim_win_get_cursor(0)[1] - 1,
      vim.api.nvim_win_get_cursor(0)[1],
      false,
      { link }
      )
    end

    keymap("n", "<leader>l", "<Nop>", { desc = "Links" })
    keymap("n", "<leader>la", paste_absolute_path, { desc = "Paste absolute path" })
    keymap("n", "<leader>lm", function() paste_markdown_link(false) end , { desc = "Paste markdown link" })
    keymap("n", "<leader>lM", function() embed_markdown_link(true) end , { desc = "Embed markdown link" })
    -- keymap("n", "<leader>lo", paste_obsidian_link, { desc = "Paste obsidian link" })
    -- keymap("n", "<leader>lo", embed_obsidian_link, { desc = "Embed obsidian link" })
    keymap("n", "<leader>lr", paste_relative_path, { desc = "Paste relative path" })
    keymap("n", "<leader>ly", copy_file_path, { desc = "Copy file path" })
