local theme = "catppuccin"

return {
	{ "rebelot/kanagawa.nvim", lazy = true, priority = 1000 },
	{ "folke/tokyonight.nvim", lazy = true, priority = 1000 },
	{ "embark-theme/vim", name = "embark", lazy = true, priority = 1000 },
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		opts = {
			flavour = "mocha",
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd.colorscheme(theme)
		end,
	},
}
