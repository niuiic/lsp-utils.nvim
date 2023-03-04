local lua = require("niuiic-core").lua

local get_active_clients = function()
	local lsps = vim.lsp.get_active_clients()
	return lua.list.map(lsps, function(lsp)
		return lsp.name
	end)
end

return {
	get_active_clients = get_active_clients,
}
