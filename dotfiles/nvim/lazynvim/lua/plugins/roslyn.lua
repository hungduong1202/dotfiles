return {
  {
    "seblyng/roslyn.nvim",
    ft = { "cs", "razor", "cshtml" },

    opts = {
      filewatching = "roslyn", -- rất quan trọng cho solution lớn
      broad_search = true, -- cần cho MAUI
      lock_target = true, -- tránh attach nhầm solution
      silent = false,
    },

    config = function(_, opts)
      -- setup plugin
      require("roslyn").setup(opts)

      -- setup LSP server settings
      require "lsp.roslyn"
    end,
  },
}
