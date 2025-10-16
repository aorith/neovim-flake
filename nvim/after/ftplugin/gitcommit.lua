vim.bo.textwidth = 72

vim.wo[0][0].colorcolumn = '+0'
vim.wo[0][0].foldmethod = 'expr'
vim.wo[0][0].foldexpr = 'v:lua.MiniGit.diff_foldexpr()'
