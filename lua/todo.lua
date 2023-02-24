local commands = require("todo.commands")
local config = require("todo.config")
local highlights = require("todo.highlights")
local md_queries = require("todo.markdown.queries")

local Self = {}

function Self.setup(options)
	config.setup(options)
	commands.add_user_commands()

	md_queries.configure_parser_and_queries()
	highlights.set_highlights()
end

return Self
