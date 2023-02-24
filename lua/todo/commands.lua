local notify = require("todo.notify")
local buffer = require("todo.buffer")
local tasks_picker = require("todo.pickers.tasks")

local Self = { _name = "Commands" }

local commands = {
	_default = buffer.open,
	open = buffer.open,
	tasks = tasks_picker.tasks_list,
}

local function get_fn_and_args(fargs)
	local command_fn, command_args, commands_node = nil, {}, commands

	for _, arg in ipairs(fargs) do
		if command_fn then
			table.insert(command_args, arg)
		elseif type(commands_node[arg]) == "function" then
			command_fn = commands_node[arg]
		elseif type(commands_node[arg]) == "table" then
			commands_node = commands_node[arg]
		else
			break
		end
	end

	return command_fn, command_args
end

local function run(opts)
	local command_fn, command_args

	-- check if table is empty
	if next(opts.fargs) == nil then
		command_fn, command_args = commands._default, {}
	else
		command_fn, command_args = get_fn_and_args(opts.fargs)
	end

	if command_fn then
		local ok, result = pcall(command_fn, unpack(command_args))

		if ok then
			return result
		end

		notify.err(string.format("Fail to run [%s]\n%s", opts.args, result), Self)
		return false
	else
		print(vim.inspect(opts.args))
		print(vim.inspect(opts.fargs))

		notify.err("Invalid command: " .. opts.args, Self)
		return false
	end
end

local function complete_suggestions(arg, commands_node)
	local result = {}

	if not commands_node then
		return result
	end

	for key, _ in pairs(commands_node) do
		if key ~= "_default" and vim.startswith(key, arg) then
			table.insert(result, key)
		end
	end

	return result
end

local function complete(_, line)
	local args = vim.split(line:gsub("^Todo ", ""), "%s+")
	local current_node = commands
	local last_arg = ""

	for index, arg in ipairs(args) do
		if index ~= #args and type(current_node[arg]) == "table" then
			current_node = current_node[arg]
		elseif index ~= #args then
			current_node = nil
		else
			last_arg = arg
		end
	end

	return complete_suggestions(last_arg, current_node)
end

function Self.add_user_commands()
	vim.api.nvim_create_user_command("Todo", run, { nargs = "*", complete = complete })
end

return Self
