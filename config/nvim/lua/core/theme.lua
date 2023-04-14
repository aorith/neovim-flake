local M = {}
vim.o.background = "dark"

local theme = "catppuccin"

M.theme_name = function()
  return theme
end

M.setup = function()
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
  end

  --- nord
  if theme == "nord" then
    vim.g.nord_borders = true
    vim.g.nord_bold = false

    -- Load the colorscheme
    require("nord").set()
    vim.cmd.colorscheme("nord")
  end

  --- catppuccin
  if theme == "catppuccin" then
    require("catppuccin").setup({
      background = {
        light = "latte",
        dark = "mocha", -- frappe, macchiato, mocha
      },
      show_end_of_buffer = true, -- show the '~' characters after the end of buffers
      term_colors = true,
      dim_inactive = {
        enabled = true,
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
        navic = true,
        --mini = true,
        markdown = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    })

    -- setup must be called before loading
    vim.cmd.colorscheme("catppuccin")
  end

  --- gruvbox
  if theme == "gruvbox" then
    require("gruvbox").setup({})
    vim.cmd.colorscheme("gruvbox")
  end

  --- gruvbox-material
  if theme == "gruvbox-material" then
    vim.cmd.colorscheme("gruvbox-material")
  end

  --- tokyonight
  if theme == "tokyonight" then
    require("tokyonight").setup({
      style = "moon", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
      sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
      day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
      dim_inactive = true, -- dims inactive windows
    })

    vim.cmd.colorscheme("tokyonight")
  end

  -- onedark
  if theme == "onedark" then
    require("onedark").load()
  end
end

return M
