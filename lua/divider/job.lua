local search = function(pattern, file)
	if not file then
		file = vim.api.nvim_buf_get_name(0)
	end

	local output = vim.fn.systemlist({ "rg", "-e " .. pattern, file, "--vimgrep" })
	local res = {}
	for _, value in ipairs(output) do
		table.insert(res, value)
	end
	return res
end

return {
	search = search,
}
