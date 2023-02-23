local Self = {}

local function read_query_file(format)
	local files = vim.treesitter.get_query_files(format, "highlights", nil)

	if files[1] then
		return vim.fn.join(vim.fn.readfile(files[1]), "\n")
	end

	return ""
end

local function set_query(format, type, add)
	vim.treesitter.query.set_query(format, type, read_query_file(format) .. add)
end

function Self.tasks()
	local tasks_query = [[
  ; query
  (section 
    (atx_heading 
      (atx_h2_marker)
      heading_content: (inline) @headerCapture
       )) @sectionCapture
  ]]

	return vim.treesitter.parse_query("markdown", tasks_query)
end

function Self.status()
	return vim.treesitter.parse_query("markdown_inline", "(link_text) @statusCapture")
end

function Self.due()
	return vim.treesitter.parse_query("markdown_inline", "(emphasis) @emphasisCapture")
end

function Self.merge_highlights()
	-- set_query(
	-- 	"markdown",
	-- 	"highlights",
	-- 	[[
	--
	--    ; query
	--    (section
	--      (atx_heading
	--        (atx_h2_marker)
	--        heading_content: (inline) @symbol))
	--    ]]
	-- )
	--
	-- set_query(
	-- 	"markdown_inline",
	-- 	"highlights",
	-- 	[[
	--
	--    ; query
	--    (shortcut_link
	--      (link_text) @function (#eq? @function "done"))
	--    ]]
	-- )

	vim.treesitter.query.set_query(
		"todomd",
		"highlights",
		[[

    ; query
    (section
      (atx_heading
        (atx_h2_marker)
        heading_content: (inline) @symbol))
    ]]
	)
end

return Self
