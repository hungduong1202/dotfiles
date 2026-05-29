local function dashboard_sections()
	local sections = {
		{ section = "header" },
		{ section = "keys", indent = 1, gap = 1, padding = 1 },
		{ section = "recent_files", icon = " ", title = "Recent Files", cwd = true, indent = 3, padding = 2 },
		{ section = "startup" },
		{ pane = 2, padding = 2 },
	}
	local logo = vim.fs.joinpath(vim.fn.stdpath("config"), "img", "logo.jpg")
	if vim.fn.executable("ascii-image-converter") == 1 and vim.uv.fs_stat(logo) then
		sections[#sections + 1] = {
			pane = 2,
			section = "terminal",
			cmd = string.format("ascii-image-converter %s -c -b --dither", vim.fn.shellescape(logo)),
			random = 10,
			indent = 4,
			height = 30,
		}
	end
	return sections
end

return {
	"folke/snacks.nvim",
	event = "VimEnter",
	opts = function()
		return {
			bigfile = { enabled = true },
			dashboard = {
				enabled = true,
				preset = {
					header = [[
                                                                     
       ████ ██████           █████      ██                     
      ███████████             █████                             
      █████████ ███████████████████ ███   ███████████   
     █████████  ███    █████████████ █████ ██████████████   
    █████████ ██████████ █████████ █████ █████ ████ █████   
  ███████████ ███    ███ █████████ █████ █████ ████ █████  
 ██████  █████████████████████ ████ █████ █████ ████ ██████ 
      ]],
				},
				sections = dashboard_sections(),
			},
			image = { enabled = true },
			indent = { enabled = true },
			lazygit = { enabled = true },
			picker = { enabled = true },
			notifier = { enabled = true },
			quickfile = { enabled = true },
			scratch = { enabled = true },
			terminal = { enabled = true },
			words = { enabled = true },
		}
	end,
	keys = {
		{ "<leader>gg", function() Snacks.lazygit() end, desc = "[L]azy[G]it" },
		{ "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
		{ "<c-/>", function() Snacks.terminal() end, desc = "Toggle Terminal", mode = { "n", "t" } },
		{ "<c-_>", function() Snacks.terminal() end, desc = "which_key_ignore" },
		{ "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
		{ "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
		{ "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
		{ "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
		{ "<leader>sg", function() Snacks.picker.grep() end, desc = "[S]earch by [G]rep" },
		{
			"<leader>sn",
			function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end,
			desc = "[S]earch [N]eovim files",
		},
		{ "<leader>sf", function() Snacks.picker.files() end, desc = "[S]earch [F]iles" },
		{ "<leader>sp", function() Snacks.picker.pickers() end, desc = "[S]earch [P]ickers" },
		{ "<leader>s.", function() Snacks.picker.recent() end, desc = "[S]earch Recent Files ('.' for repeat)" },
		{ "<leader>sk", function() Snacks.picker.keymaps() end, desc = "[S]earch [K]eymaps" },
		{ "<leader>sw", function() Snacks.picker.grep_word() end, desc = "[S]earch current [W]ord", mode = { "n", "x" } },
		{ "<leader>sh", function() Snacks.picker.help() end, desc = "[S]earch [H]elp" },
		{ "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "[S]earch [D]iagnostics" },
		{ "<leader>s/", function() Snacks.picker.grep_buffers() end, desc = "[S]earch [/] in Open Files" },
		{
			"<leader>/",
			function()
				Snacks.picker.lines({
					layout = { preset = "select" },
				})
			end,
			desc = "[/] Fuzzily search in current buffer",
		},
	},
}
