local commands = require("todo.commands")

local function default_file()
	return vim.fn.stdpath("config") .. "/todo.md"
end

local function config_with_defaults(opts)
	return {
		todo_file = opts.todo_file or default_file(),
	}
end

local Self = {}

function Self.setup(options)
	local config = config_with_defaults(options or {})

	commands.add_user_commands()

	print(config.todo_file)
end

function Self.dothis() end

return Self
