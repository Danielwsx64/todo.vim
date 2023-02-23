local Self = {}

function Self.set_highlights()
	vim.api.nvim_set_hl(0, "@todo.title", { foreground = 11771379, bold = false })

	vim.api.nvim_set_hl(0, "@todo.due", {
		background = "#1e2a35",
		foreground = "#7f8490",
		bold = true,
	})

	vim.api.nvim_set_hl(0, "@todo.status.todo", { foreground = "#76cce0", bold = true })
	vim.api.nvim_set_hl(0, "@todo.status.doing", { foreground = "#e7c664", bold = true })
	vim.api.nvim_set_hl(0, "@todo.status.done", { foreground = "#a7df78", bold = true })
	vim.api.nvim_set_hl(0, "@todo.status.hold", { foreground = "#fc5d7c", bold = true })
end

return Self
