---@class Divider
---@field regex string
---@field hl string
---@field icon string | nil
---@field icon_hl string | nil
---@field hide boolean | nil

local config = {
	---@type Divider[]
	dividers = {},
	enabled_filetypes = {},
	highlight_current_divider = true,
	current_divider_hl = "#0083a7",
	ui = { direction = "vr", size = 40, enter = false },
}

local ns_id = vim.api.nvim_create_namespace("divider")
local ns_id2 = vim.api.nvim_create_namespace("current_divider")
local tree_view_handle

return {
	config = config,
	ns_id = ns_id,
	ns_id2 = ns_id2,
	tree_view_handle = tree_view_handle,
}
