local Window = require("divider.outline.window")

local Outline = {}

-- % new %
function Outline:new()
	local instance = {
		dividers = {},
	}

	setmetatable(instance, {
		__index = self,
	})

	return instance
end

-- % is_open %
function Outline:is_open()
	return self._outline_window and self._outline_window:is_valid()
end

-- % open_outline %
function Outline:open_outline(config)
	if self:_is_open() then
		return
	end

	self._outline_window = Window:new_split(config.win_pos, config.win_size)
end

-- % close_outline %
function Outline:close_outline() end

return Outline
