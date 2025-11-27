-- randomhue with higher saturation

local hues = require('mini.hues')

math.randomseed(vim.fn.rand())
local base_colors = hues.gen_random_base_colors()

hues.setup({
  background = base_colors.background,
  foreground = base_colors.foreground,
  n_hues = 8,
  saturation = vim.o.background == 'dark' and 'mediumhigh' or 'high',
  accent = 'bg',
})

vim.g.colors_name = 'randomhuehigh'
