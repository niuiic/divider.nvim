local DividerParsers = require("divider.dividers.divider_parsers")

-- % parse_file %
local divider_parsers = DividerParsers:new({
	{
		pattern = [[ %% (.+) %%]],
		level = 1,
		hl_group = "LineNr",
		mark_char = "-",
		mark_pos = "top",
		is_visible_in_outline = true,
		is_enabled = function()
			return true
		end,
	},
	{
		pattern = [[ %%%% (.+) %%%%]],
		level = 2,
		hl_group = "CursorLineNr",
		mark_char = "-",
		mark_pos = "top",
		is_visible_in_outline = true,
		is_enabled = function()
			return true
		end,
	},
	{
		pattern = [[ %%%%%% (.+) %%%%%%]],
		level = 3,
		hl_group = "MoreMsg",
		mark_char = "-",
		mark_pos = "top",
		is_visible_in_outline = true,
		is_enabled = function()
			return true
		end,
	},
})

local dividers = divider_parsers:parse_file(0, 0)
assert(dividers[1]:get_text() == "DividerParsers:parse_file")
