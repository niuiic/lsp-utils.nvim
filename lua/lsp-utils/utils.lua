local core = require("core")

local get_active_clients = function()
	local clients = vim.lsp.get_clients()

	local bufnr = vim.api.nvim_get_current_buf()
	clients = core.lua.list.filter(clients, function(client)
		local buffers = vim.lsp.get_buffers_by_client_id(client.id)
		if not core.lua.list.includes(buffers, function(buffer)
			return buffer == bufnr
		end) then
			return false
		end
		return true
	end)

	return core.lua.list.map(clients, function(client)
		return client.name
	end)
end

return {
	get_active_clients = get_active_clients,
}
