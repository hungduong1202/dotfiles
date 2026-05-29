return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "csharp",
      "razor",
      "html",
      "css",
    },
    highlight = { enable = true },
  },
}
