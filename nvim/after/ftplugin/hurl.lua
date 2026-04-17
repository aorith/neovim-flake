vim.keymap.set(
  'n',
  '<Leader>e',
  '<Cmd>silent w | Term hurl --color --include --pretty %<CR>',
  { buffer = 0, desc = 'Run this file with Hurl' }
)
