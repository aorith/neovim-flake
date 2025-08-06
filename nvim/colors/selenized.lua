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
    base00 = "#103c48",
    base01 = "#184956",
    base02 = "#2d5b69",
    base03 = "#72898f",
    base04 = "#72898f",
    base05 = "#adbcbc",
    base06 = "#cad8d9",
    base07 = "#cad8d9",
    base08 = "#fa5750",
    base09 = "#ed8649",
    base0A = "#dbb32d",
    base0B = "#75b938",
    base0C = "#41c7b9",
    base0D = "#4695f7",
    base0E = "#af88eb",
    base0F = "#f275be",
  }
else
  p = {
    base00 = "#fbf3db",
    base01 = "#ece3cc",
    base02 = "#d5cdb6",
    base03 = "#909995",
    base04 = "#909995",
    base05 = "#53676d",
    base06 = "#3a4d53",
    base07 = "#3a4d53",
    base08 = "#cc1729",
    base09 = "#bc5819",
    base0A = "#a78300",
    base0B = "#428b00",
    base0C = "#00978a",
    base0D = "#006dce",
    base0E = "#825dc0",
    base0F = "#c44392",
  }
end

require("mini.base16").setup({
  palette = p,
  use_cterm = true,
  plugins = plugins,
})

vim.g.colors_name = "selenized"
