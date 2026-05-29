if true then
  return {}
end

return {
  "nvim-treesitter/nvim-treesitter",
  enabled = false,
  opts = {
    ensure_installed = {
      "dart",
      "javascript",
      "typescript",
      "lua",
      "json",
      "html",
      "css",
    },
    highlight = { enable = true },
    indent = { enable = true },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["is"] = "@string.inner", -- inside string
          ["as"] = "@string.outer", -- around string
          ["ib"] = "@block.inner", -- inside block
          ["ab"] = "@block.outer", -- around block
        },
      },
    },
  },
}
