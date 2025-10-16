local hipatterns = require('mini.hipatterns')

---@diagnostic disable-next-line: redundant-parameter
hipatterns.setup({
  highlighters = {
    delay = {
      text_change = 600,
      scroll = 200,
    },

    -- Highlight standalone 'FIX', 'FIXME', 'HACK', 'TODO', 'NOTE'
    fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
    fix = { pattern = '%f[%w]()FIX()%f[%W]', group = 'MiniHipatternsFixme' },
    hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
    todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
    note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

    -- Highlight hex color strings (`#rrggbb`) using that color
    -- #992233, #229933, #223399
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})
