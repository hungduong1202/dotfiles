require "nvchad.autocmds"

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "DressingInput",
--   callback = function()
--     vim.b.blink_cmp_enabled = false
--   end,
-- })
--
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.razor", "*.cshtml" }, -- tất cả file Razor / CSHTML
  callback = function()
    vim.bo.filetype = "razor" -- set filetype thành razor
  end,
})
