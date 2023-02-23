local Self = {}

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

function Self.due()
	return vim.treesitter.parse_query(
		"markdown_inline",
		[[
    ; query
      ((emphasis) @todo.due (#lua-match? @todo.due "^%*|%d%d%d%d%-%d%d%-%d%d|%*"))
    ]]
	)
end

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

	set_query(
		"markdown_inline",
		"highlights",
		[[

	   ; query
	   (shortcut_link
       (link_text) @todo.status.todo (#eq? @todo.status.todo ":todo:"))

	   (shortcut_link
       (link_text) @todo.status.doing (#eq? @todo.status.doing ":doing:"))

	   (shortcut_link
       (link_text) @todo.status.done (#eq? @todo.status.done ":done:"))

	   (shortcut_link
       (link_text) @todo.status.hold (#eq? @todo.status.hold ":hold:"))

     ((emphasis) @todo.due (#lua-match? @todo.due "^%*|%d%d%d%d%-%d%d%-%d%d|%*"))
	   ]]
	)
end

return Self
