local Window = require("divider.outline.window")

local Outline = {}

-- % new %
function Outline:new()
	local instance = {
		_dividers = {},
		_ns_id = vim.api.nvim_create_namespace("divider.outline"),
	}

	setmetatable(instance, {
		__index = Outline,
	})

	return instance
end

-- % is_open %
function Outline:is_open()
	return self._outline_window and self._outline_window:is_valid()
end

-- % open_outline %
function Outline:open_outline(config)
	if self:is_open() then
		return
	end

	self._outline_window = Window:new_split(config.win_pos, config.win_size)
	self:_set_keymap(config)
	self:_draw_lines()
end

-- % close_outline %
function Outline:close_outline()
	if self._preview_window then
		self._preview_window:close()
	end
	if self._outline_window then
		self._outline_window:close()
	end
end

-- % set_dividers %
function Outline:set_dividers(dividers)
	self._dividers = {}

	dividers:each(function(divider)
		if divider:is_visible_in_outline() then
			table.insert(self._dividers, divider)
		end
	end)

	if self:is_open() then
		self:_draw_lines()
	end
end

-- % draw_lines %
function Outline:_draw_lines()
	local bufnr = self._outline_window:get_bufnr()

	vim.api.nvim_set_option_value("modifiable", true, {
		buf = bufnr,
	})
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})

	for index, divider in ipairs(self._dividers) do
		self:_draw_line(divider, index, bufnr)
	end

	vim.api.nvim_set_option_value("modifiable", false, {
		buf = bufnr,
	})
end

function Outline:_draw_line(divider, lnum, bufnr)
	local text =
		string.format("%s%s: %s", string.rep("  ", divider:get_level() - 1), divider:get_lnum(), divider:get_text())
	vim.api.nvim_buf_set_lines(bufnr, lnum - 1, lnum - 1, false, { text })
	vim.api.nvim_buf_add_highlight(bufnr, self._ns_id, divider:get_hl_group(), lnum - 1, 0, -1)
end

-- % set_keymap %
function Outline:_set_keymap(config)

end

-- % navigate_to_divider %
function Outline:_naviagate_to_divider(lnum)
	local divider = self:_get_divider(lnum)
	vim.api.nvim_win_set_cursor(divider:get_winnr(), { divider:get_lnum(), 0 })
end

-- % get_divider %
function Outline:_get_divider(lnum)
	return self._dividers[lnum]
end

return Outline
