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
  colored = false,
  icon_only = false,
}

local disabled_filetypes = { "dashboard", "lazy", "alpha", "neo-tree", "Trouble", "noice" }

require("lualine").setup({
  options = {
    theme = require("core.theme").theme_name(),
    icons_enabled = true,
    globalstatus = true,
    disabled_filetypes = { statusline = disabled_filetypes, winbar = disabled_filetypes },
    refresh = {
      statusline = 800,
      tabline = 800,
      winbar = 800,
    },
  },
  extensions = { "neo-tree", "quickfix", "toggleterm" }, -- TODO: trouble

  sections = {
    lualine_a = {
      "mode",
    },
    lualine_b = { "branch" },
    lualine_c = {
      {
        "diff",
        on_click = function()
          vim.cmd("Gitsigns diffthis")
        end,
      },
      {
        "diagnostics",
        on_click = function()
          -- open quickfix list when clicking on the diagnostics lualine entry
          vim.diagnostic.setqflist()
        end,
      },
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

  tabline = { lualine_a = { { "buffers", mode = 2, icons_enabled = false, symbols = { alternate_file = " " } } } },

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
    lualine_y = {},
    lualine_z = {
      filetype,
      filename,
    },
  },
  inactive_winbar = {
    lualine_y = {},
    lualine_z = {
      filetype,
      filename,
    },
  },
})
