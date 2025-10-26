local hues = require('mini.hues')

local is_dark = vim.o.background == 'dark'

local bg, fg
if is_dark then
  bg, fg = '#1d1e2c', '#efefff'
else
  bg, fg = '#fbf7f0', '#0d0e1c'
end

hues.setup({
  background = bg,
  foreground = fg,
  n_hues = is_dark and 4 or 2,
  saturation = is_dark and 'medium' or 'high',
  accent = 'red',
})

vim.g.colors_name = 'dimmed'
