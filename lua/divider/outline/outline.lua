local Window = require("divider.outline.window")

local Outline = {}

-- % new %
function Outline:new()
	local instance = {
		_dividers = {},
		_ns_id = vim.api.nvim_create_namespace("divider.outline"),
		_hl_ns_id = vim.api.nvim_create_namespace("divider.outline.highlight"),
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
	self:_set_event_handlers(config)
	self:_draw_lines()

	if config.enter_window then
		vim.api.nvim_set_current_win(self._outline_window:get_winnr())
	end
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
	vim.api.nvim_buf_set_lines(bufnr, lnum - 1, lnum, false, { text })
	vim.api.nvim_buf_add_highlight(bufnr, self._ns_id, divider:get_hl_group(), lnum - 1, 0, -1)
end

-- % set_keymap %
function Outline:_set_keymap(config)
	local bufnr = self._outline_window:get_bufnr()
	local winnr = self._outline_window:get_winnr()
	local function get_lnum()
		return vim.api.nvim_win_get_cursor(winnr)[1]
	end

	-- navigate
	vim.keymap.set("n", config.keymap_navigate, function()
		self:_naviagate_to_divider(get_lnum(), config)
	end, {
		buffer = bufnr,
	})

	-- preview
	vim.keymap.set("n", config.keymap_preview, function()
		self:_preview_divider(get_lnum(), config)
	end, {
		buffer = bufnr,
	})

	-- close
	vim.keymap.set("n", config.keymap_close, function()
		self:close_outline()
	end, {
		buffer = bufnr,
	})
end

-- % set_event_handlers %
function Outline:_set_event_handlers(config)
	local bufnr = self._outline_window:get_bufnr()
	local winnr = self._outline_window:get_winnr()

	if config.preview_on_hover then
		local prev_lnum
		vim.api.nvim_create_autocmd("CursorMoved", {
			buffer = bufnr,
			callback = function()
				local lnum = vim.api.nvim_win_get_cursor(winnr)[1]
				if prev_lnum == lnum then
					return
				end

				prev_lnum = lnum
				self:_preview_divider(lnum, config)
			end,
		})
	end

	vim.api.nvim_create_autocmd("WinLeave", {
		buffer = bufnr,
		callback = vim.schedule_wrap(function()
			local ok, value = pcall(vim.api.nvim_buf_get_var, 0, "divider")
			local is_divider_window = ok and value == "disabled"

			if self._preview_window and not is_divider_window then
				self._preview_window:close()
			end
		end),
	})
end

-- % navigate_to_divider %
function Outline:_naviagate_to_divider(lnum, config)
	local divider = self:_get_divider(lnum)
	if not divider then
		return
	end

	vim.api.nvim_set_current_win(divider:get_winnr())
	vim.api.nvim_win_set_cursor(divider:get_winnr(), { divider:get_lnum(), 0 })

	if config.close_after_navigate then
		self:close_outline()
	end
end

-- % preview_divider %
function Outline:_preview_divider(lnum, config)
	-- find divider
	local divider = self:_get_divider(lnum)
	if not divider then
		return
	end

	-- close previous preview window
	if self._preview_window and self._preview_window:is_valid() then
		self._preview_window:close()
	end

	-- open preview window
	local col
	if config.win_pos == "left" then
		col = config.win_size
	else
		col = config.preview_win_width * -1 - 2
	end
	self._preview_window = Window:new_float(
		self._outline_window:get_winnr(),
		vim.api.nvim_win_get_cursor(self._outline_window:get_winnr())[1] - 1,
		col,
		config.preview_win_width,
		config.preview_win_height
	)
	local filetype = vim.api.nvim_get_option_value("filetype", { buf = divider:get_bufnr() })
	vim.api.nvim_set_option_value("filetype", filetype, {
		buf = self._preview_window:get_bufnr(),
	})

	-- set content
	local lines = vim.api.nvim_buf_get_lines(divider:get_bufnr(), 0, -1, false)
	vim.api.nvim_buf_set_lines(self._preview_window:get_bufnr(), 0, -1, false, lines)
	local cursor_pos = vim.api.nvim_win_get_cursor(self._outline_window:get_winnr())
	vim.api.nvim_set_current_win(self._preview_window:get_winnr())
	vim.api.nvim_win_set_cursor(self._preview_window:get_winnr(), { divider:get_lnum(), 0 })
	vim.cmd("normal zz")
	local cursor_lnum = vim.api.nvim_win_get_cursor(self._preview_window:get_winnr())[1]
	vim.api.nvim_buf_add_highlight(
		self._preview_window:get_bufnr(),
		self._ns_id,
		config.hl_group,
		cursor_lnum - 1,
		0,
		-1
	)
	vim.api.nvim_set_current_win(self._outline_window:get_winnr())
	vim.api.nvim_win_set_cursor(self._outline_window:get_winnr(), cursor_pos)
end

-- % highlight_divider %
function Outline:highlight_divider(divider, config)
	if not self:is_open() then
		return
	end

	for lnum, outline_divider in ipairs(self._dividers) do
		if divider:is_same(outline_divider) then
			vim.api.nvim_buf_add_highlight(
				self._outline_window:get_bufnr(),
				self._hl_ns_id,
				config.hl_group,
				lnum - 1,
				0,
				-1
			)
			return
		end
	end
end

-- % clear_highlights %
function Outline:clear_highlights()
	if not self:is_open() then
		return
	end

	vim.api.nvim_buf_clear_namespace(self._outline_window:get_bufnr(), self._hl_ns_id, 0, -1)
end

-- % get_divider %
function Outline:_get_divider(lnum)
	return self._dividers[lnum]
end

return Outline
