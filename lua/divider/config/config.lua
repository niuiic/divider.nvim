local Config = {}

-- % new %
function Config:new(config)
	local instance = {
		_value = config,
	}

	setmetatable(instance, {
		__index = Config,
	})

	return instance
end

-- % set %
function Config:set(new_config)
	self._value = vim.tbl_deep_extend("force", self._value, new_config)
end

-- % get %
function Config:get()
	return self._value
end

return Config
