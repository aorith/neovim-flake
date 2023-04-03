require("trouble").setup({ use_diagnostic_signs = true })

vim.keymap.set(
  "n",
  "<leader>xx",
  "<cmd>TroubleToggle document_diagnostics<cr>",
  { desc = "Document Diagnostics (Trouble)" }
)
vim.keymap.set(
  "n",
  "<leader>xX",
  "<cmd>TroubleToggle workspace_diagnostics<cr>",
  { desc = "Workspace Diagnostics (Trouble)" }
)
vim.keymap.set("n", "<leader>xL", "<cmd>TroubleToggle loclist<cr>", { desc = "Location List (Trouble)" })
vim.keymap.set("n", "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", { desc = "Quickfix List (Trouble)" })
