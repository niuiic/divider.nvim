local M = {}

M.ConfigManager = {}

function M.ConfigManager:new(config)
	local config_manager = {
		config = config,
	}

	setmetatable(config_manager, {
		__index = self,
	})

	return config_manager
end

function M.ConfigManager:set(new_config)
	self.config = vim.tbl_deep_extend("force", self.config, new_config)
end

function M.ConfigManager:get()
	return self.config
end

return M
