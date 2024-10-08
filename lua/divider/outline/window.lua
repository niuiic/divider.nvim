local Window = {}

-- % new_split %
function Window:new_split(pos, size)
	local instance = {
		is_float = false,
	}

	local cur_win = vim.api.nvim_get_current_win()

	if pos == "left" then
		vim.cmd("topleft " .. size .. "vs")
	elseif pos == "right" then
		vim.cmd(size .. "vs")
	elseif pos == "bottom" then
		vim.cmd(size .. "sp")
	else
		vim.cmd("top " .. size .. "sp")
	end

	instance._winnr = vim.api.nvim_get_current_win()
	instance._bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_set_option_value("filetype", "divider_outline", {
		buf = instance._bufnr,
	})
	vim.api.nvim_win_set_buf(instance._winnr, instance._bufnr)

	vim.api.nvim_set_current_win(cur_win)

	Window:_reset_window_options(instance._winnr)

	setmetatable(instance, {
		__index = Window,
	})

	return instance
end

-- % new_float %
function Window:new_float(relative_winnr, row, col, width, height)
	local instance = {
		is_float = true,
	}

	local cur_zindex = vim.api.nvim_win_get_config(0).zindex or 0
	instance._bufnr = vim.api.nvim_create_buf(false, true)

	instance._winnr = vim.api.nvim_open_win(instance._bufnr, false, {
		relative = "win",
		win = relative_winnr,
		width = width,
		height = height,
		row = row,
		col = col,
		zindex = cur_zindex + 1,
		style = "minimal",
		border = "rounded",
	})

	Window:_reset_window_options(instance._winnr)

	setmetatable(instance, {
		__index = Window,
	})

	return instance
end

-- % get_bufnr %
function Window:get_bufnr()
	return self._bufnr
end

-- % get_winnr %
function Window:get_winnr()
	return self._winnr
end

-- % is_valid %
function Window:is_valid()
	return vim.api.nvim_buf_is_valid(self:get_bufnr()) and vim.api.nvim_win_is_valid(self:get_winnr())
end

-- % close %
function Window:close()
	pcall(function()
		vim.api.nvim_buf_delete(self:get_bufnr(), { force = true })
		vim.api.nvim_win_close(self:get_winnr(), true)
	end)
end

-- % reset_window_options %
function Window:_reset_window_options(winnr)
	vim.api.nvim_set_option_value("number", false, {
		win = winnr,
	})
	vim.api.nvim_set_option_value("relativenumber", false, {
		win = winnr,
	})
	vim.api.nvim_set_option_value("winfixwidth", true, {
		win = winnr,
	})
	vim.api.nvim_set_option_value("list", false, {
		win = winnr,
	})
	vim.api.nvim_set_option_value("wrap", true, {
		win = winnr,
	})
	vim.api.nvim_set_option_value("linebreak", true, {
		win = winnr,
	})
	vim.api.nvim_set_option_value("breakindent", true, {
		win = winnr,
	})
	vim.api.nvim_set_option_value("showbreak", "      ", {
		win = winnr,
	})
end

return Window
