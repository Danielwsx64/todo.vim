local queries = require("todo.markdown.queries")
local treesitter_query = require("vim.treesitter.query")

local trim = require("todo.utils").strings.trim
local Task = require("todo.task")

local Self = {}

local function md_root(bufnr)
	return vim.treesitter.get_parser(bufnr, "markdown"):parse()[1]:root()
end

local function md_inline_root(str)
	return vim.treesitter.get_string_parser(str, "markdown_inline"):parse()[1]:root()
end

local function get_status(root, str)
	for _, node, _ in queries.status():iter_captures(root, str) do
		local _, column = node:start()

		return column - 1, treesitter_query.get_node_text(node, str)
	end

	return -1
end

local function get_due(root, str)
	for _, node, _ in queries.due():iter_captures(root, str) do
		local _, column = node:start()

		return column, treesitter_query.get_node_text(node, str)
	end

	return -1
end

local function format_title(str, meta_one, meta_two)
	local end_ = str:len()
	end_ = meta_one > 0 and meta_one < end_ and meta_one or end_
	end_ = meta_two > 0 and meta_two < end_ and meta_two or end_

	return trim(str:sub(8, end_))
end

local function format_content(content, header)
	return content:sub(header:len() + 4, content:len())
end

------------------
---- Public
------------------

-- Return a parserd information from a TODO md file, by buffer number
function Self.parse(bufnr)
	local tasks = {}

	for _, md_captures, _ in queries.tasks():iter_matches(md_root(bufnr), bufnr) do
		local task_header = treesitter_query.get_node_text(md_captures[1], bufnr)
		local task_content = treesitter_query.get_node_text(md_captures[2], bufnr)
		local start_row, start_col = md_captures[2]:start()
		local end_row, end_col = md_captures[2]:end_()

		local header_root = md_inline_root(task_header)

		local status_start, status = get_status(header_root, task_header)
		local due_start, due = get_due(header_root, task_header)

		table.insert(
			tasks,
			Task:new({
				title = format_title(task_header, status_start, due_start),
				content = format_content(task_content, task_header),
				status = status and status:gsub("%:", "") or "todo",
				due = due and due:gsub("[%*|]", "") or due,
				meta = {
					range = { start_row, start_col, end_row, end_col },
					bufnr = bufnr,
				},
			})
		)
	end

	return tasks
end

return Self
