local ls = require("luasnip")
local s  = ls.snippet
local t  = ls.text_node
local f  = ls.function_node

local function f_date()
  return os.date("%Y-%m-%d")
end

local function f_time()
  return os.date("%H:%M")
end

local function f_datetime()
  return os.date("%Y-%m-%d %H:%M")
end

ls.add_snippets("all", {
  s("date", {
    f(f_date, {}) }
  ),
  s("time", {
    f(f_time, {}) }
  ),
  s("datetime", {
    f(f_datetime, {}) }
  ),
})
