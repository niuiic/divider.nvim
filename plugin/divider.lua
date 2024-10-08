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

-- vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
-- 	pattern = { "*" },
-- 	callback = function(args)
-- 		if
-- 			static.config.highlight_current_divider
-- 			and core.lua.list.includes(static.config.enabled_filetypes, function(v)
-- 				return v == vim.bo.filetype
-- 			end)
-- 			and static.tree_view_handle
-- 			and args.buf ~= static.tree_view_handle.bufnr
-- 		then
-- 			divider.highlight_current_divider()
-- 		end
-- 	end,
-- })
--
-- vim.api.nvim_create_user_command("DividerToggle", function()
-- 	divider.toggle_tree_view()
-- end, {})
--
-- vim.api.nvim_create_user_command("RefreshDivider", function()
-- 	if core.lua.list.includes(static.config.enabled_filetypes, function(v)
-- 		return v == vim.bo.filetype
-- 	end) then
-- 		divider.divide()
-- 	end
-- end, {})
--
-- vim.api.nvim_create_user_command("CopyDividers", function()
-- 	divider.cp_dividers()
-- end, {})
