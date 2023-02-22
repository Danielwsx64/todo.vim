local commands = require("todo.commands")
local config = require("todo.config")

local Self = {}

function Self.setup(options)
	config.setup(options)
	commands.add_user_commands()
end

return Self
