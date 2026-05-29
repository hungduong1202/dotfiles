-- ~/.config/nvim/lua/plugins/lspconfig.lua

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        nil_ls = false,
      },
    },
  },
}
