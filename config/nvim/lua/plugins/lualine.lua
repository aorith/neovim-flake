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
  component_separators = "",
  section_separators = "",
}

local filetype = {
  "filetype",
  colored = false,
  icon_only = false,
  component_separators = "",
  section_separators = "",
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
    lualine_x = {
      {
        require("noice").api.status.command.get,
        cond = require("noice").api.status.command.has,
      },
      {
        require("noice").api.status.mode.get,
        cond = require("noice").api.status.mode.has,
      },
    },
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

  tabline = {
    lualine_a = {
      {
        "buffers",
        mode = 2,
        separator = "",
        icons_enabled = false,
        symbols = { alternate_file = "" },
      },
    },
  },

  winbar = {
    lualine_b = {
      filename,
    },
    lualine_c = {
      {
        function()
          return navic.get_location()
        end,
        cond = function()
          return navic.is_available()
        end,
        component_separators = "",
        section_separators = "",
      },
    },
    lualine_x = {
      filetype,
    },
  },
  inactive_winbar = {
    lualine_b = {
      filename,
    },
    lualine_x = {
      filetype,
    },
  },
})
