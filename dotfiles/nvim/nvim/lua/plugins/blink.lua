return {
  -- 1. Cấu hình blink.cmp (Autocomplete Engine)
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    version = "1.*", -- Sử dụng bản v1 ổn định
    dependencies = {
      "folke/lazydev.nvim",
      { "saghen/blink.lib", lazy = true },
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "default",
        ["<Enter>"] = { "accept", "fallback" },
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 300 },
        ghost_text = { enabled = true },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "lazydev" },
        providers = {
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
        },
      },
      signature = { enabled = true },
    },
  },

  -- 2. Cấu hình blink.nvim (Chartoggle & Tree)
  {
    "saghen/blink.nvim",
    build = "cargo build --release",
    lazy = false,
    keys = {
      -- chartoggle
      {
        "<C-;>",
        function()
          require("blink.chartoggle").toggle_char_eol(";")
        end,
        mode = { "n", "v" },
        desc = "Toggle ; at end of line",
      },
      {
        ",",
        function()
          require("blink.chartoggle").toggle_char_eol(",")
        end,
        mode = { "n", "v" },
        desc = "Toggle , at end of line",
      },
      -- BlinkTree
      { "<C-e>", "<cmd>BlinkTree reveal<cr>", desc = "Reveal current file in tree" },
      { "<leader>E", "<cmd>BlinkTree toggle<cr>", desc = "Toggle file tree" },
      { "<leader>e", "<cmd>BlinkTree toggle-focus<cr>", desc = "Toggle file tree focus" },
    },
    opts = {
      chartoggle = { enabled = true },
      tree = { enabled = true },
    },
  },
}
