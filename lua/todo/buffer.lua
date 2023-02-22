local config = require("todo.config")

local Self = { bufnr = -1 }

local function showup()
	local winid = vim.fn.bufwinid(Self.bufnr)
	print(winid)

	if winid == -1 then
		return vim.api.nvim_win_set_buf(0, Self.bufnr)
	end

	return vim.api.nvim_set_current_win(winid)
end

local function create_buf(todo_file)
	Self.bufnr = vim.fn.bufadd(todo_file)
end

function Self.open()
	create_buf(config.get("todo_file"))
	showup()
end

return Self
