return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- HTML
        html = {
          filetypes = { "html" },
        },

        -- Roslyn LSP (C# + Razor)
        roslyn = {
          cmd = {
            "dotnet",
            vim.fn.expand "~/.dotnet/tools/Microsoft.CodeAnalysis.LanguageServer",
          },
          filetypes = { "cs", "razor" },
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern("*.sln", "*.csproj", ".git")(fname)
          end,
        },
      },
    },
  },
}
