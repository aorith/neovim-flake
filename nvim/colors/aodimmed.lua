local hues = require("mini.hues")

local is_dark = vim.o.background == "dark"
local bg, fg = "#0d0e1c", "#ffffff"

hues.setup({
  background = is_dark and bg or fg,
  foreground = is_dark and fg or bg,
  n_hues = 2,
  saturation = is_dark and "medium" or "high",
  accent = "bg",
})

vim.g.colors_name = "aodimmed"
