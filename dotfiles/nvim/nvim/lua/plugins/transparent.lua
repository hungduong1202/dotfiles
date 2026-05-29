if false then
	return {}
end
return {
	"xiyaowong/transparent.nvim",
	lazy = false,
	priority = 1000, -- load sớm trước colorscheme
	config = function()
		require("transparent").setup({
			extra_groups = {
				-- UI cơ bản
				"NormalFloat",
				"FloatBorder",
				"SignColumn",
				"NormalNC",

				-- Snacks.nvim
				"SnacksNormal",
				"SnacksFloat",
				"SnacksExplorer",

				-- nếu dùng thêm UI khác (optional nhưng nên có)
				"NeoTreeNormal",
				"NeoTreeNormalNC",
				"TelescopeNormal",
				"TelescopeBorder",
			},
			exclude_groups = {},
		})

		-- Fix bị colorscheme override
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				local groups = {
					"Normal",
					"NormalFloat",
					"FloatBorder",
					"SignColumn",
					"NormalNC",
					"SnacksNormal",
					"SnacksFloat",
					"SnacksExplorer",
				}

				for _, group in ipairs(groups) do
					vim.api.nvim_set_hl(0, group, { bg = "none" })
				end
			end,
		})
	end,
}
