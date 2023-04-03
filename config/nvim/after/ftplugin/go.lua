vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.shiftwidth = 4
vim.bo.expandtab = false

-- Requires "ThePrimeagen/refactoring.nvim" to be installed directly and not throught null-ls
local augroup = vim.api.nvim_create_augroup("LspFormatting_Go", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.go" },
  group = augroup,
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- avoid format and code_action in the same autocmd event
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = { "*.go" },
  group = augroup,
  callback = function()
    vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
  end,
})
