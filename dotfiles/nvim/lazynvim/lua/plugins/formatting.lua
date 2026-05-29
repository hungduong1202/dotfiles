return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      nixfmt = {},
      prettier = {},
      xmllint = {
        command = "xmllint",
        args = { "--format", "-" },
        stdin = true,
      },
      csharpier = {
        command = "csharpier",
        args = { "--write-stdout" },
        stdin = true,
      },
    },
    formatters_by_ft = {
      xml = { "xmllint" }, -- brew install libxml2
      json = { "prettier" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      -- csharp = { "csharpier" }, -- thêm cho .NET / C#
      nix = { "alejandra" },
    },
  },
}
