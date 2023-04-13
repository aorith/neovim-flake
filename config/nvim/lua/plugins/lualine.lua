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
    component_separators = "|",
    section_separators = "",
    icons_enabled = true,
    globalstatus = true,
    disabled_filetypes = { statusline = disabled_filetypes, winbar = disabled_filetypes },
  },
  extensions = { "neo-tree", "quickfix", "toggleterm", "trouble" },

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
      { "%P %l:%c%V", padding = { left = 1, right = 1 } }, -- cursor location
    },
    lualine_z = {
      function()
        return "0x%B"
      end,
    },
  },
  inactive_sections = {},

  --[[
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
  --]]

  winbar = {
    lualine_a = {
      { "%n" },
    },
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
    lualine_a = {
      { "%n" },
    },
    lualine_b = {
      filename,
    },
    lualine_x = {
      filetype,
    },
  },
})
