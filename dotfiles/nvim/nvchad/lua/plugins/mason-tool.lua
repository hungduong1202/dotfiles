-- ~/.config/nvim/lua/plugins/mason-tools.lua

return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  opts = {
    ensure_installed = {
      -- === Language Servers ===
      "typescript-language-server",
      "html-lsp",
      "css-lsp",
      "json-lsp",
      "eslint-lsp",
      "tailwindcss-language-server",
      "emmet-ls",
      "svelte-language-server",
      "vue-language-server",
      "angular-language-server",
      "graphql-language-service-cli",
      "marksman",
      "yaml-language-server",
      "bash-language-server",
      "dockerls",
      "docker-compose-language-service",

      -- === C# / .NET ===
      "omnisharp",
      "netcoredbg",
      "csharpier",

      -- === Python ===
      "pyright",
      "ruff",
      "ruff-lsp",
      "black",
      "isort",
      "debugpy",

      -- === Formatters ===
      "prettier",
      "stylua",
      "beautysh",
      "yamlfmt",
      "mdformat",

      -- === Linters ===
      "eslint_d",
      "stylelint",
      "markdownlint",
      "shellcheck",
      "hadolint",
      "yamllint",

      -- === Debuggers (DAP) ===
      "js-debug-adapter",
      "dart-debug-adapter",

      -- === Optional Dev Tools ===
      "actionlint",
      "jq",
      "markdown-toc",
    },
    auto_update = false,
    run_on_start = true,
    start_delay = 3000,
    -- debounce_hours = 5,
    integrations = {
      ["mason-lspconfig"] = true,
      ["mason-null-ls"] = true,
      ["mason-nvim-dap"] = true,
    },
  },
}
