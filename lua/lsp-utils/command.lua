local static = require("lsp-utils.static")
local lsp = require("lsp-utils.lsp")
local lua = require("niuiic-core").lua

local registered_commands = {}

local create_user_commands = function()
	-- collect registered commands
	registered_commands = {}
	for _, lsp_config in pairs(static.config.lsps) do
		for _, command_map in ipairs(lsp_config.commands_map) do
			if
				lua.list.includes(registered_commands, function(v)
					return v == command_map.map[2]
				end) == false
			then
				table.insert(registered_commands, command_map.map[2])
			end
		end
	end

	for _, command in ipairs(registered_commands) do
		vim.api.nvim_create_user_command(command, function()
			local active_clients = lsp.get_active_clients()

			-- filter to get available clients
			---@type {name: string, command: string}[]
			local available_clients = {}
			for lsp_name, lsp_config in pairs(static.config.lsps) do
				-- filter client which is not working
				if lua.list.includes(active_clients, function(v)
					return lsp_name == v
				end) == false then
					goto continue
				end
				-- filter client which doesn't have this command
				for _, value in ipairs(lsp_config.commands_map) do
					if value.map[2] == command and (value.enable == nil or value.enable()) then
						table.insert(available_clients, {
							name = lsp_name,
							command = value.map[1],
						})
						break
					end
				end
				::continue::
			end

			-- exec command
			if #available_clients == 0 then
				vim.notify("no active lsp client supports this command", vim.log.levels.WARN)
			elseif #available_clients == 1 then
				vim.notify(available_clients[1].name .. " is working", vim.log.levels.INFO)
				vim.cmd(available_clients[1].command)
			else
				local clients = lua.list.map(available_clients, function(client)
					return client.name
				end)
				vim.ui.select(clients, { prompt = "select specific lsp" }, function(choice)
					local client = lua.list.filter(available_clients, function(client)
						return client.name == choice
					end)[1]
					vim.notify(client.name .. " is working", vim.log.levels.INFO)
					vim.cmd(client.command)
				end)
			end
		end, {})
	end
end

return { create_user_commands = create_user_commands }
