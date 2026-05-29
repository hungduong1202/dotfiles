return {
  "olimorris/persisted.nvim",
  event = "VimEnter",
  config = function()
    require("persisted").setup {
      save_dir = vim.fn.stdpath "data" .. "/sessions/",
      use_git_branch = true,
      autosave = true,
      autoload = true,
    }
  end,
}
