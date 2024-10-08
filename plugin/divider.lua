local divider = require("divider")

vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "BufWritePost" }, {
	pattern = { "*" },
	callback = function()
		local bufnr = vim.api.nvim_get_current_buf()
		local winnr = vim.api.nvim_get_current_win()
		if divider.is_enabled(bufnr, winnr) then
			divider.update_dividers(bufnr, winnr)
		end
	end,
})

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
	pattern = { "*" },
	callback = function()
		local bufnr = vim.api.nvim_get_current_buf()
		local winnr = vim.api.nvim_get_current_win()
		if divider.is_enabled(bufnr, winnr) then
			local lnum = vim.api.nvim_win_get_cursor(winnr)[0]
			divider.highlight_current_divider_in_outline(lnum)
		end
	end,
})
