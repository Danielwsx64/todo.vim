local Self = { _name = "Config" }

local config = nil

local default_config = {
	todo_file = vim.fn.stdpath("config") .. "/tasks.md",
	available_status = { "todo", "doing", "done", "hold" },
	highlights = {
		markdown = {
			task = {
				title = { foreground = 11771379, bold = false },
				due_date = { background = "#1e2a35", foreground = "#7f8490", bold = true },
			},
			status = {
				todo = { foreground = "#76cce0", bold = true },
				doing = { foreground = "#e7c664", bold = true },
				done = { foreground = "#a7df78", bold = true },
				hold = { foreground = "#fc5d7c", bold = true },
			},
		},
		telescope = {
			status = {
				todo = "TelescopeResultsTitle",
				doing = "TelescopeResultsConstant",
				done = "TelescopeResultsFunction",
				hold = "TelescopePreviewWrite",
			},
		},
	},
}

function Self.setup(options)
	config = vim.tbl_deep_extend("force", default_config, options or {})
end

function Self.get(key)
	return config[key]
end

return Self
