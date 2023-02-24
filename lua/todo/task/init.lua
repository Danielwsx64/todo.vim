Task = {
	title = "",
	content = "",
	status = "todo",
	due = nil,
	meta = {
		range = nil,
		bufnr = nil,
	},
}

function Task:new(attributes)
	local task = attributes or {}

	setmetatable(task, self)
	self.__index = self

	return task
end

function Task:due_date_with_icon()
	if self.due then
		return "  " .. self.due
	end

	return "   unknown"
end

function Task:status_with_icon()
	if self.status == "todo" then
		return " TODO"
	end

	if self.status == "doing" then
		return " DOING"
	end

	if self.status == "done" then
		return " DONE"
	end

	if self.status == "hold" then
		return " HOLD"
	end
end

function Task:split_content()
	if self.content then
		return vim.fn.split(self.content, "\n")
	end

	return { "-- no content --" }
end

function Task:on_line_title()
	return self.status .. self.title .. (self.due or "")
end

function Task:get_bufnr()
	return self.meta.bufnr
end

function Task:get_range()
	return self.meta.range
end

return Task
