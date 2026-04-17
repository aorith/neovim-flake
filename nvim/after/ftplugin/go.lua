vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.expandtab = false

vim.b.miniindentscope_disable = true

vim.keymap.set('n', '<Leader>e', '<Cmd>silent w | Term go run %<CR>', { buffer = 0, desc = 'Run this file with Go' })
