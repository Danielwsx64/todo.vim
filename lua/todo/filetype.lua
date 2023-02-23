local Self = {}

function Self.set_autocmd()
	local group = vim.api.nvim_create_augroup("TODOFileType", { clear = true })

	vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
		group = group,
		pattern = { "*.todomd" },
		callback = function()
			vim.api.nvim_buf_set_option(0, "filetype", "todomd")
		end,
	})
end

return Self
