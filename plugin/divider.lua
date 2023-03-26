local divider = require("divider")
local static = require("divider.static")
local core = require("niuiic-core")

vim.api.nvim_create_autocmd({ "BufWinEnter", "BufWritePost" }, {
	pattern = { "*" },
	callback = function()
		if
			core.lua.list.includes(static.config.enabled_filetypes, function(v)
				return v == vim.bo.filetype
			end)
		then
			divider.divide(static.config.dividers)
		end
	end,
})

vim.api.nvim_create_user_command("DividerToggle", function()
	divider.toggle_tree_view()
end, {})
