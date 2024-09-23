local manager = require("divider.config.manager")

---@class divider.Config
---@field dividers any[]
---@field outline divider.OutlineConfig
local default_config = {}

---@class divider.OutlineConfig
---@field pos 'top' | 'bottom' | 'left' | 'right' | 'float'
---@field width number
---@field height number

return manager.ConfigManager(default_config)
