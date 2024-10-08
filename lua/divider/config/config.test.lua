local Config = require("divider.config.config")

-- % set %
local cfg = Config:new({ a = { 1, 2, 3 }, c = { 1, 2 } })

local new_config = { b = 2, c = { 4, 5 } }
cfg:set(new_config)

assert(cfg:get().a[1] == 1)
assert(cfg:get().a[2] == 2)
assert(cfg:get().a[3] == 3)
assert(cfg:get().b == 2)
assert(cfg:get().c[1] == 4)
assert(cfg:get().c[2] == 5)
