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

local components = {
  mode = {
    "mode",
    icons_enabled = true,
    fmt = function(str)
      return str:sub(1, 3)
    end,
  },

  ls_status = {
    ls_status,
  },

  location = {
    "%l:%c%V %P 0x%B",
    padding = { left = 1, right = 1 },
  },

  filename = {
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
  },

  filetype = {
    "filetype",
    colored = true,
    icon_only = true,
    padding = { left = 1, right = 0 },
  },

  diagnostics = {
    "diagnostics",
    sources = { "nvim_lsp" },
    symbols = { error = " ", warn = " ", info = " ", hint = " " },
    on_click = function()
      -- open quickfix list when clicking on the diagnostics lualine entry
      vim.diagnostic.setqflist()
    end,
  },
}

require("lualine").setup({
  options = {
    component_separators = "",
    section_separators = "",
    icons_enabled = true,
    globalstatus = false,
  },
  extensions = { "neo-tree", "quickfix", "toggleterm", "trouble" },

  sections = {
    lualine_a = { components.mode },
    lualine_b = {},
    lualine_c = { components.filetype, components.filename, components.diagnostics },

    lualine_x = { components.ls_status },
    lualine_y = { components.location },
    lualine_z = {},
  },

  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { components.filetype, components.filename },

    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
})
