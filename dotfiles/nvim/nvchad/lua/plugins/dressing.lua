return {
  "stevearc/dressing.nvim",
  event = "VeryLazy",
  opts = {
    input = {
      enabled = true,
      default_prompt = "➤ ",
      border = "rounded",
      relative = "cursor",
      prefer_width = 40,
    },
    select = {
      enabled = true,
      backend = { "telescope", "builtin" },
    },
  },
}
