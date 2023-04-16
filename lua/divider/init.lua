local job = require("divider.job")
local ui = require("divider.ui")
local static = require("divider.static")
local core = require("niuiic-core")

---@param matched_lines string[]
---@param divider_config Divider
---@return Tree.Node[]
local parse = function(matched_lines, divider_config, level)
	local nodes = {}
	local winnr = vim.api.nvim_get_current_win()
	for _, value in ipairs(matched_lines) do
		local line_nr = string.match(value, "(%d+):%d+")
		local content = string.match(value, divider_config.content_regex)
		if line_nr and content then
            local icon_hl
            if divider_config.icon_hl then
               icon_hl = "DividerIcon" .. level
            end

			table.insert(nodes, {
				label = content,
				action = {
					on_click = function()
                        vim.api.nvim_set_current_win(winnr)
						vim.api.nvim_win_set_cursor(winnr, {tonumber(line_nr), 0})
					end,
				},
				status = { expanded = true },
				option = {
                    hl = 'Divider' .. level,
					icon = divider_config.icon,
					icon_hl = icon_hl,
					hide = divider_config.hide,
				},
				level = level,
				children = {},
				extend = {
					line = tonumber(line_nr)
				},
			})
		end
	end
	return nodes
end

local highlight_current_divider = ui.highlight_current_divider_wrapper()

---@param divider_config_list Divider[]
---@param create_tree_view boolean | nil
local divide = function(divider_config_list, create_tree_view)
	vim.api.nvim_buf_clear_namespace(0, static.ns_id, 0, -1)

	local nodes = {}
	local file = vim.api.nvim_buf_get_name(0)
	for level, divider_config in ipairs(divider_config_list) do
		local matched_lines = job.search(divider_config.divider_regex, file)
		if #matched_lines == 0 then
			goto continue
		end

        nodes =	core.lua.list.merge(nodes, parse(matched_lines, divider_config, level))

		::continue::
	end

	ui.highlight_divider(nodes, static.ns_id)
    if static.tree_view_handle then
        ui.refresh_tree_view(nodes)
    elseif create_tree_view then
        ui.create_tree_view(nodes)
    end
    highlight_current_divider()
end

local toggle_tree_view = function()
	if static.tree_view_handle then
        if
            not vim.api.nvim_win_is_valid(static.tree_view_handle.winnr)
            or not vim.api.nvim_buf_is_valid(static.tree_view_handle.bufnr)
        then
            pcall(vim.api.nvim_buf_delete, static.tree_view_handle.bufnr, { force = true, unload = false })
            static.tree_view_handle = nil
            divide(static.config.dividers, true)
        else
            pcall(vim.api.nvim_buf_delete, static.tree_view_handle.bufnr, { force = true, unload = false })
            static.tree_view_handle = nil
        end
	else
        divide(static.config.dividers, true)
	end
end

local setup = function(new_config)
	static.config = vim.tbl_deep_extend("force", static.config, new_config or {})
	ui.create_hl_group(static.config.dividers)
end


return {
	setup = setup,
	divide = divide,
    toggle_tree_view = toggle_tree_view,
    highlight_current_divider = highlight_current_divider
}
