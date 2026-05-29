require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "lua", "dartls" }
vim.lsp.enable(servers)

vim.filetype.add {
  extension = {
    razor = "razor",
    cshtml = "razor",
  },
}

-- read :h vim.lsp.config for changing options of lsp servers
