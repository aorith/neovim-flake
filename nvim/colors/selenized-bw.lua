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
    base00 = "#181818",
    base01 = "#252525",
    base02 = "#3b3b3b",
    base03 = "#777777",
    base04 = "#777777",
    base05 = "#b9b9b9",
    base06 = "#dedede",
    base07 = "#dedede",
    base08 = "#ed4a46",
    base09 = "#e67f43",
    base0A = "#dbb32d",
    base0B = "#70b433",
    base0C = "#3fc5b7",
    base0D = "#368aeb",
    base0E = "#a580e2",
    base0F = "#eb6eb7",
  }
else
  p = {
    base00 = "#ffffff",
    base01 = "#ebebeb",
    base02 = "#cdcdcd",
    base03 = "#878787",
    base04 = "#878787",
    base05 = "#474747",
    base06 = "#282828",
    base07 = "#282828",
    base08 = "#bf0000",
    base09 = "#ba3700",
    base0A = "#af8500",
    base0B = "#008400",
    base0C = "#009a8a",
    base0D = "#0054cf",
    base0E = "#6b40c3",
    base0F = "#dd0f9d",
  }
end

require("mini.base16").setup({
  palette = p,
  use_cterm = true,
  plugins = plugins,
})

vim.g.colors_name = "selenized-bw"
