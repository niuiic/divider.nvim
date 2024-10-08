local config = require("divider.config")

local M = {}

M.setup = function(new_config)
	config:set(new_config)
end

return M
