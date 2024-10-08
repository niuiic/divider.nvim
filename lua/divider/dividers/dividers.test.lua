local Dividers = require("divider.dividers.dividers")
local Divider = require("divider.dividers.divider")

-- % Dividers:_get_sorted_dividers %
local sorted_dividers = Dividers:_get_sorted_dividers({
	Divider:new("", 10, 1, 1, {}),
	Divider:new("", 1, 1, 1, {}),
	Divider:new("", 30, 1, 1, {}),
	Divider:new("", 2, 1, 1, {}),
})

local lnums = { 1, 2, 10, 30 }
for i, sorted_divider in ipairs(sorted_dividers) do
	assert(sorted_divider:get_lnum() == lnums[i])
end

-- % Dividers:find %
local dividers = Dividers:new(sorted_dividers)
assert(dividers:find(3):get_lnum() == 2)
assert(dividers:find(2):get_lnum() == 2)
