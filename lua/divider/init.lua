local utils = require("divider.utils")
local ui = require("divider.ui")
local static = require("divider.static")

local highlight_current_divider_handle = ui.highlight_current_divider_wrapper()

---@param create_tree_view boolean | nil
local divide = function(create_tree_view)
	vim.api.nvim_buf_clear_namespace(0, static.ns_id, 0, -1)

	local nodes = utils.search(vim.api.nvim_win_get_number(0))

	ui.highlight_divider(nodes, static.ns_id)

	if static.tree_view_handle then
		ui.refresh_tree_view(nodes)
	elseif create_tree_view then
		ui.create_tree_view(nodes)
	end

	highlight_current_divider_handle.reset_range()
	highlight_current_divider_handle.highlight_current_divider()
end

local toggle_tree_view = function()
	if static.tree_view_handle then
		if
			not vim.api.nvim_win_is_valid(static.tree_view_handle.winnr)
			or not vim.api.nvim_buf_is_valid(static.tree_view_handle.bufnr)
		then
			pcall(vim.api.nvim_buf_delete, static.tree_view_handle.bufnr, { force = true, unload = false })
			static.tree_view_handle = nil
			divide(true)
		else
			pcall(vim.api.nvim_buf_delete, static.tree_view_handle.bufnr, { force = true, unload = false })
			static.tree_view_handle = nil
		end
	else
		divide(true)
	end
end

local setup = function(new_config)
	static.config = vim.tbl_deep_extend("force", static.config, new_config or {})
	ui.create_hl_group(static.config.dividers)
end

return {
	setup = setup,
	divide = divide,
	cp_dividers = utils.cp_dividers,
	toggle_tree_view = toggle_tree_view,
	highlight_current_divider = highlight_current_divider_handle.highlight_current_divider,
}
