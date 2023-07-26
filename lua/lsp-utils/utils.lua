local lua = require("core").lua

local get_active_clients = function()
	return lua.list.map(vim.lsp.get_clients(), function(lsp)
		return lsp.name
	end)
end

return {
	get_active_clients = get_active_clients,
}
