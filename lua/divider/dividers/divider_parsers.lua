local DividerParser = require("divider.dividers.divider_parser")

local DividerParsers = {}

-- % new %
function DividerParsers:new(configs)
	local parsers = {}
	for _, config in ipairs(configs) do
		table.insert(parsers, DividerParser:new(config))
	end

	local instance = {
		_parsers = parsers,
	}

	setmetatable(instance, {
		__index = DividerParsers,
	})

	return instance
end

-- % parse_file %
function DividerParsers:parse_file(bufnr, winnr)
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local dividers = {}

	for lnum, line in ipairs(lines) do
		local ok, divider = pcall(function()
			return self:_parse_line(line, lnum, bufnr, winnr)
		end)
		if ok then
			table.insert(dividers, divider)
		end
	end

	return dividers
end

function DividerParsers:_parse_line(text, lnum, bufnr, winnr)
	for _, parser in ipairs(self._parsers) do
		local ok, divider = pcall(function()
			return parser:parse_line(text, lnum, bufnr, winnr)
		end)
		if ok then
			return divider
		end
	end
	error("failed to parse this line")
end

return DividerParsers
