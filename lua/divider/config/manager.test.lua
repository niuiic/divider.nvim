---@diagnostic disable: missing-fields

local manager = require("divider.config.manager")

-- % ConfigManager:set %
local cfg = manager.ConfigManager:new({
	outline = {
		pos = "left",
	},
})

local new_config = {
	outline = {
		width = 100,
	},
}
cfg:set(new_config)

assert(cfg:get().outline.pos == "left")
assert(cfg:get().outline == 100)
assert(#cfg:get().dividers == 0)
