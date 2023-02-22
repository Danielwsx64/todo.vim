local notify = require("todo.notify")

local Self = { _icon = "" }
local function fakefn(valor)
	return function()
		print("fakefn " .. (valor or ""))
	end
end

local commands = {
	["open"] = fakefn("open"),
	["one"] = {
		["one_first"] = fakefn("one_first"),
		["one_second"] = fakefn("one_second"),
		["two"] = {
			["two_first"] = fakefn("two_first"),
			["two_second"] = fakefn("two_second"),
		},
	},
}

local function run(opts)
	local command_fn
	local command_args = {}
	local commands_node = commands

	for _, arg in ipairs(opts.fargs) do
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

	if command_fn then
		local ok, result = pcall(command_fn, unpack(command_args))

		if ok then
			return result
		end

		notify.err(string.format("Fail to run [%s]\n%s", opts.args, result), Self)
		return false
	else
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
		table.insert(result, key)
	end

	if arg == "" then
		return result
	end

	return vim.tbl_filter(function(val)
		return vim.startswith(val, arg)
	end, result)
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
