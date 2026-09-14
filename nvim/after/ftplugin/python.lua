-- Format code selection lines and pressing gq
-- Format entire buffer with gggqG
vim.bo.shiftwidth = 4
vim.bo.expandtab = true

Keys.map_buffer(
  'n',
  '<Leader>e',
  "<Cmd>silent w | Term sh -c 'if command -v python; then python %; else python3 %; fi'<CR>",
  'Run this file with Python'
)
