local winid = vim.api.nvim_get_current_win()

vim.wo[winid][0].foldmethod = 'expr'
vim.wo[winid][0].foldexpr = 'v:lua.MiniGit.diff_foldexpr()'

Keys.map_buffer('n', 'K', '<Cmd>lua MiniGit.show_at_cursor()<CR>', 'Show git diff at cursor')
