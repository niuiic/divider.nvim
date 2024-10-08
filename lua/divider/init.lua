local config = require("divider.config")
local Dividers = require("divider.dividers").Dividers
local DividerParsers = require("divider.dividers").DividerParsers
local Decorator = require("divider.decorator")
local Outline = require("divider.outline")

local M = {
	divider_parsers = DividerParsers:new(config:get().dividers),
	dividers = {},
	decorator = Decorator:new(),
	outline = Outline:new(),
}

-- % setup %
M.setup = function(new_config)
	config:set(new_config)
	M.divider_parsers = DividerParsers:new(config:get().dividers)
end

-- % update_dividers %
M.update_dividers = function(bufnr, winnr)
	M.dividers = Dividers:new(M.divider_parsers:parse_file(bufnr, winnr))
	M.decorator:clear_decorations(bufnr)
	M.decorator:decorate_dividers(M.dividers)
end

-- % toggle_outline %
M.toggle_outline = function() end

return M
