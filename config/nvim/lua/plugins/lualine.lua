local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local function ls_status()
  local msgs = vim.lsp.util.get_progress_messages()
  if #msgs > 0 then
    local msg = msgs[#msgs]
    local spinner
    if msg.percentage then
      spinner = spinner_frames[(msg.percentage % #spinner_frames) + 1]
    else
      spinner = ""
    end
    return spinner .. " " .. msg.title .. ", " .. msg.message
  end

  return ""
end

local filename = {
  "filename",
  file_status = true,
  newfile_status = true,
  path = 1,
  shorting_target = 40,

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
  icon_only = true,
  padding = { left = 1, right = 0 },
}

local disabled_filetypes = { "dashboard", "lazy", "alpha", "neo-tree", "Trouble", "noice" }

require("lualine").setup({
  options = {
    component_separators = "",
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
    lualine_b = {},
    lualine_c = {
      filetype,
      filename,
    },

    lualine_x = {
      { ls_status },
      {
        "diagnostics",
        on_click = function()
          -- open quickfix list when clicking on the diagnostics lualine entry
          vim.diagnostic.setqflist()
        end,
      },
    },
    lualine_y = {
      { "%l:%c%V %P 0x%B", padding = { left = 1, right = 1 } }, -- cursor location
    },
    lualine_z = {},
  },
  inactive_sections = {},
})
