vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.expandtab = false

vim.b.miniindentscope_disable = true

Keys.map_buffer('n', '<Leader>e', '<Cmd>silent w | Term go run %<CR>', 'Run this file with Go')
