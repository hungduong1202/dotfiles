local map = vim.keymap.set

map("i", "jj", "<ESC>")

map("c", ";", "<ESC>")

map("n", ";", ":", { desc = "CMD enter command mode" })

map("n", "<S-l>", "<cmd>bn<cr>")

map("n", "<S-h>", "<cmd>bp<cr>")

map("n", "<leader>bb", "<C-^>")

map("n", "<leader>bd", "<cmd>bd<cr>")

map("n", "<C-a>", "ggVG")
