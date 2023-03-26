---@param regex string
---@param file string
---@return string[]
local search = function(regex, file)
	return vim.fn.systemlist({ "rg", "-e " .. regex, file, "--vimgrep" })
end

return {
	search = search,
}
