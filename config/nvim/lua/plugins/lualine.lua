local navic = require("nvim-navic")

local filename = {
  "filename",
  file_status = true,
  newfile_status = true,
  path = 1,
  shorting_target = 35,

  symbols = {
    modified = "[+]",
    readonly = "[RO]",
    unnamed = "[No Name]",
    newfile = "[New]",
  },
}

local filetype = {
  "filetype",
  colored = true,
  icon_only = false,
}

local disabled_filetypes = { "dashboard", "lazy", "alpha", "neo-tree", "Trouble", "noice" }

require("lualine").setup({
  options = {
    theme = require("core.theme").theme_name(),
    icons_enabled = true,
    disabled_filetypes = { statusline = disabled_filetypes, winbar = disabled_filetypes },
    refresh = {
      statusline = 500,
      tabline = 1000,
      winbar = 500,
    },
  },
  extensions = { "neo-tree", "nvim-tree", "quickfix", "fugitive" },

  sections = {
    lualine_a = {
      "mode",
    },
    lualine_b = { "branch" },
    lualine_c = {
      { "diff" },
      { "diagnostics" },
    },
    lualine_x = {},
    lualine_y = {
      { "progress", separator = " ", padding = { left = 1, right = 0 } },
      { "location", padding = { left = 0, right = 1 } },
    },
    lualine_z = {
      function()
        return "0x%B"
      end,
    },
  },
  inactive_sections = {},

  tabbar = {},

  winbar = {
    lualine_x = {
      {
        function()
          return navic.get_location()
        end,
        cond = function()
          return navic.is_available()
        end,
      },
    },
    lualine_y = {
      filetype,
    },
    lualine_z = {
      filename,
    },
  },
  inactive_winbar = {
    lualine_y = {
      filetype,
    },
    lualine_z = {
      filename,
    },
  },
})
