local config = require("todo.config")
local Self = {}

function Self.set_highlights()
	local config_hl = config.get("highlights")

	vim.api.nvim_set_hl(0, "@todo.title", config_hl.markdown.task.title)
	vim.api.nvim_set_hl(0, "@todo.due", config_hl.markdown.task.due_date)

	for status, hl in pairs(config_hl.markdown.status) do
		vim.api.nvim_set_hl(0, "@todo.status." .. status, hl)
	end
end

function Self.telescope_status_hl(task)
	local config_hl = config.get("highlights")

	return config_hl.telescope.status[task.status] or "TelescopeResultsNormal"
end

return Self
