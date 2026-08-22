vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.expandtab = false

vim.b.miniindentscope_disable = true

Bufmap({ '<Leader>e', '<Cmd>silent w | Term go run %<CR>', desc = 'Run this file with Go' })
