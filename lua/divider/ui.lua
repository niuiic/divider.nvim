local core = require("niuiic-core")
local static = require("divider.static")

---@param divider_config_list Divider[]
local create_hl_group = function(divider_config_list)
	for i, config in ipairs(divider_config_list) do
		vim.api.nvim_set_hl(0, "Divider" .. i, { fg = config.hl })
		if config.icon_hl then
			vim.api.nvim_set_hl(0, "DividerIcon" .. i, { fg = config.icon_hl })
		end
	end
end

---@param nodes Tree.Node[]
---@param ns_id number
local highlight_divider = function(nodes, ns_id)
	for _, node in ipairs(nodes) do
		vim.api.nvim_buf_add_highlight(0, ns_id, "Divider" .. node.level, node.extend.line - 1, 0, -1)
	end
end

---@param nodes Tree.Node[]
---@return Tree.Node[]
local tree = function(nodes)
	local root = {
		children = {},
	}
	nodes = core.lua.list.sort(nodes, function(prev, cur)
		return prev.extend.line > cur.extend.line
	end)
	for index, node in ipairs(nodes) do
		if node.level > 1 then
			for i = index - 1, 1, -1 do
				if nodes[i].level < node.level then
					table.insert(nodes[i].children, node)
					goto continue
				end
			end
		end
		table.insert(root.children, node)
		::continue::
	end
	return root.children
end

---@param nodes Tree.Node[]
local create_tree_view = function(nodes)
	static.tree_view_handle = core.tree.create_tree_view(tree(nodes), static.config.ui)
	vim.api.nvim_buf_set_option(static.tree_view_handle.bufnr, "filetype", "divider")
end

local refresh_tree_view = function(nodes)
	if
		vim.api.nvim_win_is_valid(static.tree_view_handle.winnr)
		and vim.api.nvim_buf_is_valid(static.tree_view_handle.bufnr)
	then
		core.tree.refresh_tree_view(tree(nodes), static.tree_view_handle.bufnr, static.tree_view_handle.tree_view)
	end
end

return {
	create_hl_group = create_hl_group,
	highlight_divider = highlight_divider,
	create_tree_view = create_tree_view,
	refresh_tree_view = refresh_tree_view,
}
