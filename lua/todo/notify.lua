local Self = {}

local function build_title(mod)
	local plugin_name = "Todo"

	return mod._name and string.format("%s [ %s ]", plugin_name, mod._name) or plugin_name
end

local function get_icon(mod)
	local plugin_icon = ""
	return mod._icon or plugin_icon
end

local function build_params(mod)
	return { title = build_title(mod), icon = get_icon(mod) }
end

function Self.info(message, mod)
	vim.notify(message, "info", build_params(mod))
end

function Self.warn(message, mod)
	vim.notify(message, "warn", build_params(mod))
end

function Self.err(message, mod)
	vim.notify(message, "error", build_params(mod))
end

function Self.debug(message, mod)
	vim.notify(message, "debug", build_params(mod))
end

return Self
