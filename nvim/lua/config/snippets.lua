local ok_ls, ls = pcall(require, "luasnip")
if not ok_ls then
  return
end

local s = ls.snippet
local f = ls.function_node

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
  s({ trig = "date", wordTrig = true }, {
    f(f_date, {})
  }),
  s({ trig = "time", wordTrig = true }, {
    f(f_time, {})
  }),
  s({ trig = "datetime", wordTrig = true }, {
    f(f_datetime, {})
  }),
})

