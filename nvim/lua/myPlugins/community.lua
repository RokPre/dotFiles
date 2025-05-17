-- TODO: Sort by birthdays
-- TODO: Add caching,

-- Constants
M = {}

M.path = "~/sync/vault/Ljudje/"
M.template = "~/sync/vault/template/Neovim-ljudlje-template.md"
M.sort = "score"   -- score, name, most interacted (score changes, daily note)
M.sortOrder = true -- true = asc, false = desc
M.scorePattern = "tocke"
M.blockPattern = "blokiran"
M.socialPattern = "druženje:"

local function getLines(person)
  local home = os.getenv("HOME")
  local path = M.path .. person -- Avoid fnameescape for file IO
  -- path = vim.fn.fnameescape(path)
  path = path:gsub("~", home)
  -- vim.print("Resolved path:", path)

  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then
    vim.print("Failed to read file: " .. path)
    return {}
  end
  return lines
end

-- utils
local function getScore(person)
  local lines = getLines(person)

  for _, line in ipairs(lines) do
    local score = line:match("^" .. M.scorePattern .. ":%s*(.+)")
    if score then return score end
  end

  return nil
end

local function getInteractionCount(person)
  -- TODO: Use treesiter to count the number of headings that also contain a date.
  local lines = getLines(person)
  local count = 0
  for _, line in ipairs(lines) do
    if line:find("^#") then
      count = count + 1
    end
  end
  return count
end

local function lastInteractionTime(person)
  local lines = getLines(person)
  for _, line in ipairs(lines) do
    if line:find("^#") then
      -- vim.print("line: " .. line)
      local ok, datetime = pcall(function() return line:match("#%s*(%d%d%d%d%-%d%d%-%d%d %d%d:%d%d)") end)
      -- vim.print("Datetime: ",datetime)
      if datetime and ok then
        local year, month, day, hour, min = datetime:match("(%d+)%-(%d+)%-(%d+) (%d+):(%d+)")
        local timestamp = os.time({
          year = tonumber(year),
          month = tonumber(month),
          day = tonumber(day),
          hour = tonumber(hour),
          min = tonumber(min),
          sec = 0,
        })
        -- vim.print("Timestamp: ", timestamp)
        if year == nil then year = "" end
        if month == nil then month = "" end
        if day == nil then day = "" end
        return timestamp * 1000, year, month, day -- Convert to milliseconds
      end
    end
  end
  return 0
end


local function getPeople()
  local people = vim.fn.system("ls " .. M.path)
  -- vim.print("People", people)
  -- vim.print(type(people))
  -- vim.print(vim.split(people, "\n"))
  local people_list = vim.split(people, "\n")
  return people_list
end

local function getRelevantInfo(person, sortType)
  if sortType == "name" then
    return ""
  elseif sortType == "score" then
    return ""
  elseif sortType == "most interacted" then
    return getInteractionCount(person)
  elseif sortType == "most recent" then
    return lastInteractionTime(person)
  end
end

local function sortPeople(people, sortType, sortDir)
  if sortType == "name" then
    table.sort(people, function(a, b)
      if sortDir then
        return a < b
      else
        return a > b
      end
    end)
  elseif sortType == "score" then
    table.sort(people, function(a, b)
      local sa = tonumber(getScore(a)) or -math.huge
      local sb = tonumber(getScore(b)) or -math.huge
      if sortDir then
        return sa < sb
      end
      return sa > sb
    end)
  elseif sortType == "most interacted" then
    table.sort(people, function(a, b)
      local sa = tonumber(getInteractionCount(a)) or -math.huge
      local sb = tonumber(getInteractionCount(b)) or -math.huge
      if sortDir then
        return sa < sb
      end
      return sa > sb
    end)
  elseif sortType == "most recent" then
    table.sort(people, function(a, b)
      local timestamp_a, _, _, _ = lastInteractionTime(a)
      local timestamp_b, _, _, _ = lastInteractionTime(b)
      local sa = tonumber(timestamp_a) or -math.huge
      local sb = tonumber(timestamp_b) or -math.huge
      if sortDir then
        return sa < sb
      end
      return sa > sb
    end)
  end

  return people
end

local function insertTamplate()
  local template_path = M.template:gsub("~", os.getenv("HOME"))
  vim.api.nvim_win_set_cursor(0, { 1, 0 })
  local ok, template_lines = pcall(vim.fn.readfile, template_path)
  if not ok then
    vim.notify("Failed to read template: " .. template_path, vim.log.levels.ERROR)
    return
  end

  for i, line in ipairs(template_lines) do
    template_lines[i] = line:gsub("{{date}}", os.date("%Y-%m-%d %H:%M")):gsub("{{dateX}}", os.time(os.date("!*t")))
  end

  vim.api.nvim_buf_set_lines(0, 0, -1, false, template_lines)
  vim.cmd("write")
end

local function newPerson()
  local name = vim.fn.input("Name: ")
  if name == "" then
    vim.print("Please enter a name")
    return
  end

  local home = tostring(os.getenv("HOME"))
  local filename = M.path .. name .. ".md"
  local template_path = M.template:gsub("~", home)

  vim.cmd("e " .. vim.fn.fnameescape(filename))

  insertTamplate()
end

local function showPeople(people)
  local newPersonString = "+ add new person"
  -- TODO: Find the empty string and remove it properly
  table.remove(people, #people)
  people = sortPeople(people, M.sort, M.sort_order)
  table.insert(people, newPersonString)
  vim.ui.select(people, {
    prompt = "Select a person",
    format_item = function(item)
      if item == newPersonString then
        return item
      end
      -- TODO: If sort type is score, then this is redundant, otherwise it is not.
      local score = getScore(item)
      score = tostring(score)
      -- TODO: I am getting relevant_info twice, as i am already checking it in the sort function.
      local relevant_info, year, month, day = getRelevantInfo(item, M.sort)
      if year ~= nil and month ~= nil and day ~= nil then
        if year ~= "" and month ~= "" and day ~= "" then
          relevant_info = year .. "-" .. month .. "-" .. day
        end
      end
      return relevant_info .. " " .. score .. " " .. item:gsub(".md", "")
    end,
  }, function(selected)
    if not selected then
      return
    end
    if selected == newPersonString then
      newPerson()
      return
    end
    -- vim.print(M.path .. vim.fn.fnameescape(selected))
    vim.cmd("e " .. M.path .. vim.fn.fnameescape(selected))
  end)
end

local function log()
  -- Move to top before searching
  local file = vim.fn.expand("%:p")
  local expected_path = M.path:gsub("~", os.getenv("HOME"))
  if not file:find(expected_path, 1, true) then
    vim.print("Not in the right folder")
    return
  end
  vim.api.nvim_win_set_cursor(0, { 1, 0 })

  -- Find first '---' (start of YAML)
  local yaml_start = vim.fn.search("^---", "nW")
  if yaml_start == 0 then
    vim.notify("No YAML start marker '---' found", vim.log.levels.ERROR)
    return
  end

  -- Find second '---' (end of YAML)
  local yaml_end = vim.fn.search("^---", "nW")
  if yaml_end == 0 then
    vim.notify("No YAML end marker '---' found", vim.log.levels.ERROR)
    return
  end

  -- Insert log below YAML
  local date = os.date("%Y-%m-%d %H:%M")
  local log_line = "# " .. date
  vim.fn.append(yaml_end, { log_line, "", "" })

  vim.cmd("write")

  -- Move cursor to start of log and enter insert mode
  vim.api.nvim_win_set_cursor(0, { yaml_end + 2, 0 })
  vim.cmd("startinsert!")
end

local function changeScore(change)
  -- Check if in the right file
  local file = vim.fn.expand("%:p")
  local expected_path = M.path:gsub("~", os.getenv("HOME"))
  if not file:find(expected_path, 1, true) then
    vim.print("Not in the right folder")
    return
  end

  -- Search for the score line in YAML
  local score_line = vim.fn.search("^" .. M.scorePattern, "n")
  -- vim.print(score_line)
  if score_line == 0 then
    vim.print("Score line not found")
    return
  end

  local line = vim.fn.getline(score_line)
  -- vim.print(line)
  local current_score = tonumber(line:match("-?%d+"))
  if not current_score then
    vim.print("Could not parse current score")
    return
  end

  local new_score = tostring(current_score + change)
  local new_line = line:gsub(tostring(current_score), tostring(new_score), 1)
  vim.fn.setline(score_line, new_line)

  -- Find end of frontmatter to add log (look for line with just "---")
  local yaml_end = vim.fn.search("^---", "n")
  -- vim.print(type(yaml_end))
  if yaml_end == 0 or yaml_end <= score_line then
    yaml_end = score_line + 1
  end

  local date = os.date("%Y-%m-%d %H:%M")
  local log = "# " ..
      date ..
      " " ..
      (change >= 0 and "+" or "") .. tostring(change) .. "(" .. tostring(current_score) .. "->" .. new_score .. ")"
  -- vim.print("yaml_end type: " .. type(yaml_end) .. ", score_line type: " .. type(score_line))
  vim.fn.append(yaml_end, log)
  vim.fn.append(yaml_end + 1, "")
  vim.fn.append(yaml_end + 2, "")

  vim.cmd("write")
  vim.print("Score updated to " .. new_score)

  -- Move cursor to log
  vim.api.nvim_win_set_cursor(0, { yaml_end + 2, 0 })
  vim.cmd("startinsert!")
  -- Enter insert mode
end


local function blockPerson()
  local file = vim.fn.expand("%:p")
  local expected_path = M.path:gsub("~", os.getenv("HOME"))
  if not file:find(expected_path, 1, true) then
    vim.print("Not in the right folder")
    return
  end

  local block_line = vim.fn.search("^" .. M.blockPattern, "nw")
  if block_line == 0 then
    vim.print("Blokiran line not found")
    return
  end

  local line = vim.fn.getline(block_line)
  local value = line:match(M.blockPattern .. ":%s*(%a+)")
  vim.print("Current value:", value)

  if value == "true" then
    vim.fn.setline(block_line, "blokiran: false")
  else
    vim.fn.setline(block_line, "blokiran: true")
  end
end

local function isBlocked(person)
  local path = (M.path .. person):gsub("~", os.getenv("HOME"))
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then
    vim.print("Failed to read file: " .. path)
    return false
  end

  for _, line in ipairs(lines) do
    local value = line:match(M.blockPattern .. ":%s*(%a+)")
    if value then
      return value == "true"
    end
  end

  return false
end

local function social()
  local activities = {}
  local home = os.getenv("HOME")
  local path
  local started
  local ended
  local activity
  local people = getPeople()
  table.remove(people, #people)


  for _, person in ipairs(people) do
    -- Check if person is blocked
    if isBlocked(person) then
      goto continue
    end

    started = false
    ended = false

    local lines = getLines(person)

    for _, line in ipairs(lines) do
      if line:find(M.socialPattern) then
        -- vim.print("Found start", line)
        started = true
      end
      if started then
        if not line:find("  - ") and not line:find(M.socialPattern) then
          -- vim.print("Found end", line)
          ended = true
          goto continue
        end
      end
      if started and not ended and not line:find(M.socialPattern) then
        -- vim.print("Found activity in line: ", line)
        activity = line:gsub("^%s*%-%s*", "")
        -- vim.print("Activity:", activity)
        activities[activity] = activities[activity] or {}
        table.insert(activities[activity], person)
      end
    end
    ::continue::
  end

  -- vim.print(activities)
  local keys = vim.tbl_keys(activities)
  table.sort(keys, function(a, b) return #activities[a] > #activities[b] end)
  vim.ui.select(keys, {
    prompt = "Chose an activity",
  }, function(selected)
    if not selected then
      return
    end
    local people = activities[selected]
    people = sortPeople(people, M.sort, M.sort_order)
    vim.ui.select(people, {
      prompt = "Select a person",
      format_item = function(item)
        local score = getScore(item)
        score = tostring(score)
        return score .. " " .. item:gsub(".md", "")
      end,
    }, function(selected)
      if not selected then
        return
      end
      -- vim.print(M.path .. vim.fn.fnameescape(selected))
      vim.cmd("e " .. M.path .. vim.fn.fnameescape(selected))
    end)
  end)
end

local function sortSwitch()
  local sortType = { "name", "score", "most interacted", "most recent" }
  local index = 1
  for i, sort in ipairs(sortType) do
    if sort == M.sort then
      index = i
      break
    end
  end
  index = index + 1
  if index > #sortType then
    index = 1
  end
  M.sort = sortType[index]
  vim.print("Sorting by:", M.sort)
end

local function sortOrder()
  -- toggle the sort order (asc/desc)
  -- true = asc, false = desc
  M.sort_order = not M.sort_order
  vim.print("Sorting order:", M.sort_order)
end


M.people = getPeople()

-- TODO: Color the people based on ther relationship score
-- local ns_id_good = vim.api.nvim_create_namespace("GoodScore")
-- local ns_id_bad = vim.api.nvim_create_namespace("BadScore")
-- vim.api.nvim_set_hl(0, "GoodScore", { bg = "#00ff00", fg = "#ffffff", bold = true })
-- vim.api.nvim_set_hl(0, "BadScore", { bg = "#ff0000", fg = "#ffffff", bold = true })

vim.keymap.set("n", "<Leader>c", "<Nop>", { silent = true, desc = "Community" })
vim.keymap.set("n", "<Leader>cc", function() showPeople(getPeople()) end, { silent = true, desc = "Show community" })
vim.keymap.set("n", "<Leader>cf", "<cmd> e " .. M.path .. "<Cr>", { silent = true, desc = "Open community folder" })
vim.keymap.set("n", "<Leader>ci", function() changeScore(1) end, { silent = true, desc = "Increase score" })
vim.keymap.set("n", "<Leader>cd", function() changeScore(-1) end, { silent = true, desc = "Decrease score" })
vim.keymap.set("n", "<Leader>cl", log, { silent = true, desc = "Add log" })
vim.keymap.set("n", "<Leader>cb", blockPerson, { silent = true, desc = "Block person" })
vim.keymap.set("n", "<Leader>cs", sortSwitch, { silent = true, desc = "Switch sorting" })
vim.keymap.set("n", "<Leader>co", sortOrder, { silent = true, desc = "Sort order" })
vim.keymap.set("n", "<Leader>ca", social, { silent = true, desc = "Activities" })
vim.keymap.set("n", "<Leader>ct", insertTamplate, { silent = true, desc = "Insert template" })
