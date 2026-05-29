return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	opts = {
		ensure_installed = {
			"bash",
			"c",
			"diff",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"query",
			"vim",
			"vimdoc",
			"rust",
			"regex",
			"php",
			"blade",
			"javascript",
			"typescript",
			"css",
			"json",
			"prisma",
			"tsx",
			"nix",
		},
	},
	config = function(_, opts)
		-- nvim-treesitter rewrite (main): setup() only honors install_dir; old keys like
		-- ensure_installed / highlight / indent are ignored — install parsers explicitly and
		-- call vim.treesitter.start() per buffer (see plugin README).
		require("nvim-treesitter").setup({})

		local langs = opts.ensure_installed or {}
		if #langs > 0 then
			require("nvim-treesitter").install(langs)
		end

		local group = vim.api.nvim_create_augroup("nvim-treesitter-filetype", { clear = true })
		vim.api.nvim_create_autocmd("FileType", {
			group = group,
			pattern = "*",
			callback = function()
				if not pcall(vim.treesitter.start) then
					return
				end
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
