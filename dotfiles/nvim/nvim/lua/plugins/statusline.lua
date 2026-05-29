return {
	"nvim-mini/mini.statusline",
	event = "VeryLazy",
	version = false,
	config = function()
		local ms = require("mini.statusline")
		ms.setup({ use_icons = vim.g.have_nerd_font })
		---@diagnostic disable-next-line: duplicate-set-field
		ms.section_location = function()
			return "%2l:%-2v"
		end
	end,
}
