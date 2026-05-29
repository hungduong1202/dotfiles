require "nvchad.mappings"

local map = vim.keymap.set
local nomap = vim.keymap.del

local function del(mode, keys)
  pcall(vim.keymap.del, mode, keys)
end

map("i", "jk", "<ESC>")

map("c", ";", "<ESC>")

map("n", ";", ":", { desc = "CMD enter command mode" })

map("n", "<S-l>", "<cmd>bnext<CR>")

map("n", "<S-h>", "<cmd>bprev<CR>")

map("n", "<leader>bb", "<C-^>")

map("n", "<leader>bd", "<cmd>bd<cr>")

-- map("n", "<leader>bo", "<cmd>bd | %bd | e#<cr>")

map("n", "<C-a>", "ggVG")

-- map("n", "<leader>e", "<cmd>Neotree toggle<CR>")

-- map("n", "<leader><leader>", "<cmd>Telescope find_files<CR>")

map("n", "<leader>sk", "<cmd>Telescope keymaps<CR>")

map("n", "<leader>/", "<cmd>Telescope live_grep<CR>")

del("n", "<leader>ra")

map("n", "<leader>ca", vim.lsp.buf.code_action, {
  desc = "LSP Code Action",
})

-- del("n", "<leader>e")

map("n", "<leader>e", function()
  require("snacks.explorer").open()
end, { desc = "Snacks Explorer" })

local function floating_rename()
  local curr_name = vim.fn.expand "<cword>"

  vim.ui.input({ prompt = "Rename To: ", default = curr_name }, function(new_name)
    if new_name and #new_name > 0 and new_name ~= curr_name then
      vim.lsp.buf.rename(new_name)
    end
  end)
end

vim.keymap.set("n", "<leader>cr", floating_rename, { desc = "Floating LSP Rename" })

map("n", "<leader>uC", function()
  require("nvchad.themes").open()
end, {})

local function close_other_buffers()
  local current = vim.api.nvim_get_current_buf()

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, "buflisted") then
      vim.api.nvim_buf_delete(buf, { force = false })
    end
  end
end

map("n", "<leader>bo", close_other_buffers, { desc = "Close other buffers" })
