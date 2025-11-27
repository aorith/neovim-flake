---@diagnostic disable-next-line: redundant-parameter
require('mini.indentscope').setup({
  draw = {
    animation = require('mini.indentscope').gen_animation.none(),
  },
})

Config.new_autocmd('FileType', {
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
}, function() vim.b.miniindentscope_disable = true end, 'Disable mini indent scope')
