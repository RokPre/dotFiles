local function testFunction1(input1)
	return input1 + 1
end

local function testFunction2(input2)
	return input2 + 1
end

-- [ ... Go to previous start
-- ] ... Go to next start
-- { ... Go to previous end
-- } ... Go to next end
-- local function testFunction1(input1)
-- 	return input1 + 1
-- end{f
--
-- [flocal function󰹞testFunction2(input2)
-- 	return input2 + 1
-- end}f
-- ]f does not put me anywhere as this is go to next start function which does not exist as this would be the last function in the file.
--
--
-- [flocal function testFunction1(input1)
-- 	return input1 + 1
-- en󰹞
--
-- ]flocal function testFunction2(input2)
-- 	return input2 + 1
-- end}f
-- {f does not put me anywhere as this is go to previous end function which does not exist as this would be the first function in the file.
