local static = require("lsp-utils.static")
local command = require("lsp-utils.command")

local setup = function(new_config)
	static.config = vim.tbl_deep_extend("force", static.config, new_config or {})
	command.create_user_commands()
end

return {
	setup = setup,
}
