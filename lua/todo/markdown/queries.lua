local Self = {}
function Self.tasks()
	local tasks_query = [[
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

return Self
