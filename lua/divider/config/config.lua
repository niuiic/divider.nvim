---@class divider.Config
local Config = {}

function Config:new(config)
	local cfg = {
		_value = config,
	}

	setmetatable(cfg, {
		__index = self,
	})

	return cfg
end

function Config:set(new_config)
	self._value = vim.tbl_deep_extend("force", self._value, new_config)
end

function Config:get()
	return self._value
end

return Config
