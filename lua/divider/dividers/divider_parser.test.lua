local DividerParser = require("divider.dividers.divider_parser")

-- % parse_line %
local divider_parser = DividerParser:new({
	pattern = [[ %% (.+) %%]],
	level = 1,
	hl_group = "LineNr",
	mark_char = "-",
	mark_pos = "top",
	is_visible_in_outline = true,
	is_enabled = function()
		return true
	end,
})

local ok, divider = pcall(function()
	return divider_parser:parse_line("-- % parse_line %", 1, 1, 1)
end)
assert(ok)
assert(divider:get_text() == "parse_line")

ok = pcall(function()
	return divider_parser:parse_line("-- %parse_line %", 1, 1, 1)
end)
assert(not ok)
