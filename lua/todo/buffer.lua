local config = require("todo.config")

local Self = {}

local tasks_bufnr = -1

local function show_win(bufnr, position)
	local winid = vim.fn.bufwinid(bufnr)

	if winid == -1 then
		vim.api.nvim_win_set_buf(0, bufnr)
		winid = 0
	else
		vim.api.nvim_set_current_win(winid)
	end

	if position then
		vim.api.nvim_win_set_cursor(winid, { position[1] + 1, position[2] })
	end
end

function Self.open()
	show_win(Self.fetch_bufnr())
end

function Self.fetch_bufnr()
	if tasks_bufnr == -1 then
		tasks_bufnr = vim.fn.bufadd(config.get("todo_file"))
	end

	return tasks_bufnr
end

function Self.go_to(task)
	show_win(task:get_bufnr(), task:get_range())
end

return Self
