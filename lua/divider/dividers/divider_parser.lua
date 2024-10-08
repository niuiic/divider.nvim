local Divider = require("divider.dividers.divider")

local DividerParser = {}

-- % new %
function DividerParser:new(config)
	local instance = {
		_config = config,
	}

	setmetatable(instance, {
		__index = self,
	})

	return instance
end

-- % parse_line %
function DividerParser:parse_line(text, lnum, bufnr, winnr)
	if not self._config.is_enabled(bufnr, winnr) then
		error("this parser is not enabled")
	end

	local matched_text = string.match(text, self._config.pattern)
	if not matched_text then
		error("failed to parse this line")
	end

	return Divider:new(matched_text, lnum, bufnr, winnr, self._config)
end

return DividerParser
