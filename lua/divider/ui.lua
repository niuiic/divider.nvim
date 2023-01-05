local function create_hl_group(color_group)
	for i, color in ipairs(color_group) do
		vim.api.nvim_set_hl(0, "Divider" .. i, { fg = color })
	end
end

return {
	create_hl_group = create_hl_group,
}
