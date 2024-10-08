local Decorator = {}

-- % new %
function Decorator:new()
	local instance = {
		_ns_id = vim.api.nvim_create_namespace("divider"),
	}

	setmetatable(instance, {
		__index = self,
	})

	return instance
end

-- % clear_decorations %
function Decorator:clear_decorations(bufnr)
	vim.api.nvim_buf_clear_namespace(bufnr, self._ns_id, 1, -1)
end

-- % decorate_dividers %
function Decorator:decorate_dividers(dividers)
	dividers:each(function(...)
		self:_decorate_divider(...)
	end)
end

function Decorator:_decorate_divider(divider)
	self:_highlight_divider(divider)
	if divider:get_mark_pos() ~= "none" then
		self:_mark_divider(divider)
	end
end

function Decorator:_highlight_divider(divider)
	vim.api.nvim_buf_add_highlight(divider:get_bufnr(), self._ns_id, divider:get_hl_group(), divider:get_lnum(), 0, -1)
end

function Decorator:_mark_divider(divider)
	local columns = vim.opt.columns:get()
	local mark_pos = divider:get_mark_pos()
	local mark_chars = string.rep(divider:get_mark_char(), columns)

	if mark_pos == "both" or mark_pos == "top" then
		vim.api.nvim_buf_set_extmark(divider:get_bufnr(), self._ns_id, divider:get_lnum(), 0, {
			virt_lines = { { { mark_chars, divider:get_hl_group() } } },
			virt_lines_above = true,
		})
	end

	if mark_pos == "both" or mark_pos == "bottom" then
		vim.api.nvim_buf_set_extmark(divider:get_bufnr(), self._ns_id, divider:get_lnum(), 0, {
			virt_lines = { { { mark_chars, divider:get_hl_group() } } },
		})
	end
end

return Decorator
