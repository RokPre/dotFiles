local variable = 1
local str = "Hello"

local arr = { variable, str, 0b1111 }

for _, v in ipairs(arr) do
  if type(v) == "number" then
    print("Number")
  elseif type(v) == "string" then
    print("String")
  elseif type(v) == "boolean" then
    print("Boolean")
  end
end

if type(variable) == "number" then
  if variable == 1 then
    if variable == 1 then
      if variable == 1 then
        if variable == 1 then
          print("Number 1")
        end
      end
    end
  end
end
