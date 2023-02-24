local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")
local previewers_utils = require("telescope.previewers.utils")

local markdown = require("todo.markdown")
local buffer = require("todo.buffer")
local highlights = require("todo.highlights")

local Self = { _name = "Tasks Picker" }

local displayer = entry_display.create({
	separator = " | ",
	items = {
		{ width = 13 }, -- due date
		{ width = 7 }, -- status
		{ remaining = true },
	},
})

local function previewer()
	return previewers.new_buffer_previewer({
		title = "Taks content: ",
		define_preview = function(self, entry, _)
			local task = entry.value

			vim.api.nvim_buf_set_lines(self.state.bufnr, 0, 0, true, task:split_content())
			previewers_utils.highlighter(self.state.bufnr, "markdown")
		end,
	})
end

local function build_display()
	return function(entry)
		local task = entry.value

		return displayer({
			task:due_date_with_icon(),
			{ task:status_with_icon(), highlights.telescope_status_hl(task) },
			task.title,
		})
	end
end

local function attach_mappings(prompt_bufnr, _)
	actions.select_default:replace(function()
		actions.close(prompt_bufnr)
		local selection = action_state.get_selected_entry()
		buffer.go_to(selection.value)
	end)

	return true
end

------------------
---- Public
------------------

-- Opens telescope picker with tasks from TODO md file
function Self.tasks_list(opts)
	local tasks = markdown.parse(buffer.fetch_bufnr())

	pickers.new(opts, {
		prompt_title = "TODO",
		prompt_prefix = "  ",
		results_title = "Tasks: ",
		previewer = previewer(),
		attach_mappings = attach_mappings,
		finder = finders.new_table({
			results = tasks,
			entry_maker = function(task)
				return {
					value = task,
					ordinal = task:on_line_title(),
					display = build_display(),
				}
			end,
		}),
		sorter = conf.generic_sorter(opts),
	}):find()
end

return Self
