local Self = { strings = {} }

function Self.strings.trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

return Self
