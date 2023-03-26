---@class Divider
---@field divider_regex string
---@field content_regex string
---@field hl string
---@field icon string | nil
---@field icon_hl string | nil
---@field hide boolean | nil

local config = {
	---@type Divider[]
	dividers = {},
	enabled_filetypes = {},
	ui = { direction = "v", size = 40, enter = false },
}

local ns_id = vim.api.nvim_create_namespace("divider")
local tree_view_handle

return {
	config = config,
	ns_id = ns_id,
	tree_view_handle = tree_view_handle,
}
