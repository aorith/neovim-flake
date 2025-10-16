---@diagnostic disable-next-line: redundant-parameter
require('mini.indentscope').setup({
  draw = {
    animation = require('mini.indentscope').gen_animation.none(),
  },
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'help',
    'dashboard',
    'minipick',
    'bigfile',
    'Trouble',
    'trouble',
    'lazy',
    'mason',
    'notify',
    'NvimTree',
    'man',
  },
  callback = function() vim.b.miniindentscope_disable = true end,
})
