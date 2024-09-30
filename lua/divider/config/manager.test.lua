local manager = require("divider.config.manager")

-- % ConfigManager:set %
local cfg = manager.ConfigManager:new({ a = 1 })

local new_config = { b = 2 }
cfg:set(new_config)

assert(cfg:get().a == 1)
assert(cfg:get().b == 2)
