local Config = require("divider.config").Config
local default_config = require("divider.config").default_config
local Dividers = require("divider.dividers").Dividers
local DividerParsers = require("divider.dividers").DividerParsers
local Decorator = require("divider.decorator")
local Outline = require("divider.outline")

local M = {}

M._config = Config:new(default_config)
M._divider_parsers = DividerParsers:new(M._config:get().dividers)
M._decorator = Decorator:new()
M._outline = Outline:new()

-- % setup %
M.setup = function(new_config)
	M._config:set(new_config)
	M._divider_parsers = DividerParsers:new(M._config:get().dividers)
end

-- % update_dividers %
M.update_dividers = function(bufnr, winnr)
	M._dividers = Dividers:new(M._divider_parsers:parse_file(bufnr, winnr))
	M._decorator:clear_decorations(bufnr)
	M._decorator:decorate_dividers(M._dividers)
	M._outline:set_dividers(M._dividers)
end

-- % toggle_outline %
M.toggle_outline = function()
	if M._outline:is_open() then
		M._outline:close_outline()
	else
		local lnum = vim.api.nvim_win_get_cursor(0)[1]
		M._outline:open_outline(M._config:get().outline)
		M.highlight_current_divider_in_outline(lnum)
	end
end

-- % is_enabled %
M.is_enabled = function(bufnr, winnr)
	return M._config:get().is_enabled(bufnr, winnr)
end

-- % highlight_current_divider_in_outline %
M.highlight_current_divider_in_outline = function(lnum)
	local divider = M._dividers:find(lnum)
	M._outline:clear_highlights()
	if divider then
		M._outline:highlight_divider(divider, M._config:get().outline)
	end
end

return M
