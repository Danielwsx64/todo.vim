local config = require("todo.config")

local Self = {}

local function read_query_file(format, type)
	local files = vim.treesitter.get_query_files(format, type, nil)

	if files[1] then
		return vim.fn.join(vim.fn.readfile(files[1]), "\n")
	end

	return ""
end

local function set_query(format, type, add)
	vim.treesitter.query.set_query(format, type, read_query_file(format, type) .. add)
end

local function build_queries_for_status()
	local queries = ""

	for _, status in ipairs(config.get("available_status")) do
		queries = string.format(
			[[
      ; query
      (shortcut_link
         (link_text) @todo.status.%s (#eq? @todo.status.%s ":%s:"))

      %s
      ]],
			status,
			status,
			status,
			queries
		)
	end

	return queries
end

------------------
---- Public
------------------

-- Return treesitter query to fetch task section and header
function Self.tasks()
	local tasks_query = [[
  ; query
  (section 
    (atx_heading 
      (atx_h2_marker)
      heading_content: (inline) @headerCapture (#match? @headerCapture "^ TASK: ")
       )) @sectionCapture
  ]]

	return vim.treesitter.parse_query("markdown", tasks_query)
end

-- Return treesitter query to fetch header status
function Self.status()
	return vim.treesitter.parse_query(
		"markdown_inline",
		[[
    ; query
	   (shortcut_link
       (link_text) @todo.status.todo (#match? @todo.status.todo ":(todo|doing|done|hold):"))
    ]]
	)
end

-- Return treesitter query to fetch header due date
function Self.due()
	return vim.treesitter.parse_query(
		"markdown_inline",
		[[
    ; query
      ((emphasis) @todo.due (#lua-match? @todo.due "^%*|%d%d%d%d%-%d%d%-%d%d|%*"))
    ]]
	)
end

-- Configure treesitter queries for markdown and markdown_inline
function Self.configure_parser_and_queries()
	set_query(
		"markdown",
		"highlights",
		[[
	   ; query
	   (section
	     (atx_heading
	       (atx_h2_marker)
	       heading_content: (inline) @todo.title (#match? @todo.title "^ TASK: ") ))
	   ]]
	)

	set_query("markdown_inline", "highlights", [[
	   ; query
     ((emphasis) @todo.due (#lua-match? @todo.due "^%*|%d%d%d%d%-%d%d%-%d%d|%*"))
	   ]] .. build_queries_for_status())
end

return Self
