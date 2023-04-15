vim.opt.termguicolors = true
vim.o.background = "dark"

local theme = "catppuccin"

--- kanagawa
if theme == "kanagawa" then
  require("kanagawa").setup({
    compile = false, -- enable compiling the colorscheme
    dimInactive = true, -- dim inactive window `:h hl-NormalNC`
    background = { -- map the value of 'background' option to a theme
      dark = "wave", -- try "dragon" !
      light = "lotus",
    },
  })
  vim.cmd.colorscheme("kanagawa")

--- nord
elseif theme == "nord" then
  vim.g.nord_borders = true
  vim.g.nord_bold = false
  require("nord").set()
  vim.cmd.colorscheme("nord")

--- catppuccin
elseif theme == "catppuccin" then
  require("catppuccin").setup({
    background = {
      light = "latte",
      dark = "mocha", -- frappe, macchiato, mocha
    },
    show_end_of_buffer = true, -- show the '~' characters after the end of buffers
    term_colors = true,
    dim_inactive = {
      enabled = false,
      shade = "dark",
      percentage = 0.10,
    },
    integrations = {
      cmp = true,
      gitsigns = true,
      neotree = true,
      telescope = true,
      --notify = true,
      --noice = true,
      --navic = true,
      --mini = true,
      markdown = true,
      treesitter = true,
      treesitter_context = true,
      which_key = true,
    },
  })
  vim.cmd.colorscheme("catppuccin")

--- gruvbox
elseif theme == "gruvbox" then
  require("gruvbox").setup({})
  vim.cmd.colorscheme("gruvbox")

--- gruvbox-material
elseif theme == "gruvbox-material" then
  vim.cmd.colorscheme("gruvbox-material")

--- tokyonight
elseif theme == "tokyonight" then
  require("tokyonight").setup({
    style = "moon", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
    sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
    day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
    dim_inactive = true, -- dims inactive windows
  })
  vim.cmd.colorscheme("tokyonight")

-- onedark
elseif theme == "onedark" then
  require("onedark").load()
end
