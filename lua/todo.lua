local commands = require("todo.commands")
local config = require("todo.config")
local filetype = require("todo.filetype")
local md_queries = require("todo.markdown.queries")

local Self = {}

function Self.setup(options)
	config.setup(options)
	commands.add_user_commands()
	filetype.set_autocmd()

	-- local ft_to_parser = require("nvim-treesitter.parsers").filetype_to_parsername
	-- ft_to_parser.todomd = "markdown"

	--local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
	--parser_config.todomd = {
		--install_info = {
			--url = "https://github.com/MDeiml/tree-sitter-markdown",
			--location = "tree-sitter-markdown",
			--files = { "src/parser.c", "src/scanner.cc" },
			--branch = "split_parser",
		--},
		--filetype = "todomd",
		--experimental = true,
	--}

	--md_queries.merge_highlights()
end

return Self
