local plugins = {
  default = false,
  ["echasnovski/mini.nvim"] = true,
  ["nvim-neo-tree/neo-tree.nvim"] = true,
  ["williamboman/mason.nvim"] = true,
}

local is_dark = vim.o.background == "dark"
local p

if is_dark then
  p = {
    base00 = "#262c38",
    base01 = "#2d3444",
    base02 = "#3c4557",
    base03 = "#616E88",
    base04 = "#d8dee9",
    base05 = "#e5e9f0",
    base06 = "#eceff4",
    base07 = "#8fbcbb",
    base08 = "#bf616a",
    base09 = "#d08770",
    base0A = "#ebcb8b",
    base0B = "#a3be8c",
    base0C = "#88c0d0",
    base0D = "#81a1c1",
    base0E = "#b48ead",
    base0F = "#5e81ac",
  }

  require("mini.base16").setup({
    palette = p,
    use_cterm = true,
    plugins = plugins,
  })

  My.hi("MiniPickMatchMarked", { bg = p.base0E, fg = p.base00 })
  My.hi("MiniPickMatchRanges", { fg = p.base0E, bold = true })
  My.hi("MiniStatuslineFilename", { bg = p.base00, fg = p.base03 })
else
  local hues = require("mini.hues")
  p = hues.make_palette({
    background = "#e1e2e3",
    foreground = "#2a2e39",
    saturation = "high",
    accent = "bg",
    plugins = plugins,
  })
  hues.apply_palette(p)

  My.hi("MiniPickMatchRanges", { fg = p.red, bg = p.bg_edge, bold = true })
end

vim.g.colors_name = "mininord"
