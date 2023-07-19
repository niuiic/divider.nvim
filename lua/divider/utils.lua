local core = require("core")
local static = require("divider.static")

local search = function(winnr)
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

	local dividers = {}
	core.lua.list.each(lines, function(line, line_nr)
		for level, config in ipairs(static.config.dividers) do
			local res = string.match(line, config.regex)
			if res then
				local icon_hl
				if config.icon_hl then
					icon_hl = "DividerIcon" .. level
				end

				table.insert(dividers, {
					label = res,
					action = {
						on_click = function()
							vim.api.nvim_set_current_win(winnr)
							vim.api.nvim_win_set_cursor(winnr, { line_nr, 0 })
						end,
					},
					status = { expanded = true },
					option = {
						hl = "Divider" .. level,
						icon = config.icon,
						icon_hl = icon_hl,
						hide = config.hide,
					},
					level = level,
					children = {},
					extend = {
						line = line,
						line_nr = line_nr,
					},
				})
				return
			end
		end
	end)

	return dividers
end

local cp_dividers = function()
	local dividers = search(0)
	local lines = core.lua.list.map(dividers, function(divider)
		return divider.extend.line
	end)
	vim.fn.setreg("+", table.concat(lines, "\n"))
end

return {
	search = search,
	cp_dividers = cp_dividers,
}
