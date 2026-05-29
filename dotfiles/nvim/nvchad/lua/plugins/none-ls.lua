if true then
  return {}
end
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    local nls = require("null-ls")

    opts.sources = vim.list_extend(opts.sources or {}, {
      nls.builtins.formatting.stylua,
      nls.builtins.formatting.prettier.with({
        filetypes = { "xml" }, -- treat plist as xml
        extra_filetypes = { "plist" },
      }),
    })
  end,
}
