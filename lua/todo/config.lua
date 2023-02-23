local Self = { _name = "Config" }

local config = nil

local function config_with_defaults(opts)
	return {
		todo_file = opts.todo_file or vim.fn.stdpath("config") .. "/tasks.todomd",
	}
end

function Self.setup(options)
	config = config_with_defaults(options or {})

	print(config.todo_file)
end

function Self.get(key)
	return config[key]
end

return Self
