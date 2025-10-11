local M = {}

local lsp_configs = {}

---@param config table | table[]
M.add_lsp_config = function(config)
	if type(config) == table then
		table.insert(table, config)
		return
	end

	for _, v in ipairs(config) do
		table.insert(table, v)
	end
end

return M
