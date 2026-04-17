-- Format code selection lines and pressing gq
-- Format entire buffer with gggqG
vim.bo.shiftwidth = 4
vim.bo.expandtab = true

vim.keymap.set(
  'n',
  '<Leader>e',
  "<Cmd>silent w | Term sh -c 'if command -v python; then python %; else python3 %; fi'<CR>",
  { buffer = 0, desc = 'Run this file with Python' }
)
