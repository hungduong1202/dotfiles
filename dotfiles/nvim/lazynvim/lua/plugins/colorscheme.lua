return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
  },
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        float = "transparent",
        comment = { "italic" },
        conditional = { "italic" },
        keyword = { "italic" },
      },
    },
  },
  { "ellisonleao/gruvbox.nvim" },

  -- Set colorscheme manually
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },
}
