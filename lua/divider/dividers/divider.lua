local Divider = {}

-- % new %
function Divider:new(text, lnum, bufnr, winnr, config)
	local instance = {
		_text = text,
		_lnum = lnum,
		_bufnr = bufnr,
		_winnr = winnr,
		_config = config,
	}

	setmetatable(instance, {
		__index = Divider,
	})

	return instance
end

-- %% getters %%
function Divider:get_text()
	return self._text
end

function Divider:get_lnum()
	return self._lnum
end

function Divider:get_level()
	return self._config.level
end

function Divider:get_hl_group()
	return self._config.hl_group
end

function Divider:get_mark_char()
	return self._config.mark_char
end

function Divider:get_mark_pos()
	return self._config.mark_pos
end

function Divider:get_bufnr()
	return self._bufnr
end

function Divider:get_winnr()
	return self._winnr
end

function Divider:is_visible_in_outline()
	return self._config.is_visible_in_outline
end

return Divider
