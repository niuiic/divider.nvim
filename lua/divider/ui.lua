local core = require("core")
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

---@param nodes core.Tree.Node[]
---@param ns_id number
local highlight_divider = function(nodes, ns_id)
	for _, node in ipairs(nodes) do
		vim.api.nvim_buf_add_highlight(0, ns_id, "Divider" .. node.level, node.extend.line_nr - 1, 0, -1)
	end
end

---@param nodes core.Tree.Node[]
---@return core.Tree.Node[]
local tree = function(nodes)
	local root = {
		children = {},
	}
	nodes = core.lua.list.sort(nodes, function(prev, cur)
		return prev.extend.line_nr > cur.extend.line_nr
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

---@param nodes core.Tree.Node[]
local create_tree_view = function(nodes)
	static.tree_view_handle = core.tree.create_tree_view(tree(nodes), static.config.ui)
	vim.api.nvim_set_option_value("filetype", "divider", {
		buf = static.tree_view_handle.bufnr,
	})
end

---@param nodes core.Tree.Node[]
local refresh_tree_view = function(nodes)
	if
		vim.api.nvim_win_is_valid(static.tree_view_handle.winnr)
		and vim.api.nvim_buf_is_valid(static.tree_view_handle.bufnr)
	then
		core.tree.refresh_tree_view(tree(nodes), static.tree_view_handle.bufnr, static.tree_view_handle.tree_view)
	end
end

vim.api.nvim_set_hl(0, "CurrentDivider", { bg = static.config.current_divider_hl })

--- find cur_divider_index
---@param line number
---@param dividers core.Tree.Line[]
---@return number | nil
local cur_divider_index = function(line, dividers)
	local sorted_dividers = core.lua.list.sort(dividers, function(prev, cur)
		return prev.node.extend.line_nr > cur.node.extend.line_nr
	end)
	local targetIndex
	for i, v in ipairs(sorted_dividers) do
		if v.node.extend.line_nr <= line then
			targetIndex = i
		end
	end
	return targetIndex
end

--- whether in range of the previous divider
---@param line number
---@param range number[]
---@return boolean
local in_range = function(line, range)
	return range[1] and range[2] and range[1] <= line and (range[2] > line or range[2] == -1)
end

--- calc range of current divider
---@param current_divider_index number
---@param dividers core.Tree.Line[]
---@return number[]
local range = function(current_divider_index, dividers)
	local cur_divider_range = {
		dividers[current_divider_index].node.extend.line_nr,
	}
	if table.maxn(dividers) >= current_divider_index + 1 then
		cur_divider_range[2] = dividers[current_divider_index + 1].node.extend.line_nr
	else
		cur_divider_range[2] = -1
	end
	return cur_divider_range
end

local highlight_current_divider_wrapper = function()
	local prev_divider_range = {}
	local prevDividersCount = 0
	return {
		highlight_current_divider = function()
			if not static.tree_view_handle or not vim.api.nvim_buf_is_valid(static.tree_view_handle.bufnr) then
				return
			end

			local dividers = static.tree_view_handle.tree_view.lines
			local hasDividersChange = prevDividersCount ~= table.maxn(dividers)
			prevDividersCount = table.maxn(dividers)
			local line = vim.api.nvim_win_get_cursor(0)[1]
			if not hasDividersChange and in_range(line, prev_divider_range) then
				return
			end

			vim.api.nvim_buf_clear_namespace(static.tree_view_handle.bufnr, static.ns_id2, 0, -1)

			local targetIndex = cur_divider_index(line, dividers)
			targetIndex = cur_divider_index(line, dividers)
			if not targetIndex then
				prev_divider_range = {}
				return
			end

			prev_divider_range = range(targetIndex, dividers)

			vim.api.nvim_buf_add_highlight(
				static.tree_view_handle.bufnr,
				static.ns_id2,
				"CurrentDivider",
				dividers[targetIndex].line - 1,
				0,
				-1
			)
		end,
		reset_range = function()
			prev_divider_range = {}
			prevDividersCount = 0
		end,
	}
end

return {
	create_hl_group = create_hl_group,
	highlight_divider = highlight_divider,
	create_tree_view = create_tree_view,
	refresh_tree_view = refresh_tree_view,
	highlight_current_divider_wrapper = highlight_current_divider_wrapper,
}
