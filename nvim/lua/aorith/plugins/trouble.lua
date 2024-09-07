map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Workspace Diagnostics" })
map("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
require("trouble").setup({
  use_diagnostic_signs = true,
  auto_close = true,
})
