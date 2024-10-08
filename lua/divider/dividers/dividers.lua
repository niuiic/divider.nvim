local Dividers = {}

-- % new %
function Dividers:new(dividers)
	local instance = {
		_dividers = self:_get_sorted_dividers(dividers),
	}

	setmetatable(instance, {
		__index = Dividers,
	})

	return instance
end

function Dividers:_get_sorted_dividers(dividers)
	local sorted_dividers = {}

	for _, divider in ipairs(dividers) do
		local insert_pos = 1
		for index, sorted_divider in ipairs(sorted_dividers) do
			if sorted_divider:get_lnum() <= divider:get_lnum() then
				insert_pos = index + 1
			else
				break
			end
		end
		table.insert(sorted_dividers, insert_pos, divider)
	end

	return sorted_dividers
end

-- % find %
function Dividers:find(lnum)
	local target_divider

	for _, divider in ipairs(self._dividers) do
		if divider:get_lnum() <= lnum then
			target_divider = divider
		else
			break
		end
	end

	return target_divider
end

-- % each %
function Dividers:each(fn)
	for _, divider in ipairs(self._dividers) do
		fn(divider)
	end
end

return Dividers
