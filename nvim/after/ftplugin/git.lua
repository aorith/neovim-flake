local winid = vim.api.nvim_get_current_win()

vim.wo[winid][0].foldmethod = 'expr'
vim.wo[winid][0].foldexpr = 'v:lua.MiniGit.diff_foldexpr()'

vim.keymap.set('n', 'K', '<Cmd>lua MiniGit.show_at_cursor()<CR>', { buffer = 0, desc = 'Show git diff at cursor' })
