local blocked_filetypes = { ["neo-tree"] = true }

local function get_schema()
  local schema = require("yaml-companion").get_buf_schema(0)
  if schema.result[1].name == "none" then return "" end
  return schema.result[1].name
end

local M = {}

M.setup = function()
  require("mini.tabline").setup({})

  ---@diagnostic disable-next-line: redundant-parameter
  require("mini.statusline").setup({
    set_vim_settings = false,
    use_icons = true,

    content = {
      active = function()
        if blocked_filetypes[vim.bo.filetype] then return "" end

        local git = MiniStatusline.section_git({ trunc_width = 75 })
        local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 1024 })
        local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
        local filename = MiniStatusline.section_filename({ trunc_width = 140 })
        local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
        local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
        local location = MiniStatusline.section_location({ trunc_width = 75 })

        local yaml_schema = get_schema()

        return MiniStatusline.combine_groups({
          { hl = mode_hl, strings = { mode } },
          { hl = "MiniStatuslineDevinfo", strings = { git, diagnostics } },
          "%<", -- Mark general truncate point
          { hl = "MiniStatuslineFilename", strings = { filename } },
          "%=", -- End left alignment
          { hl = "MiniStatuslineModeReplace", strings = { search } },
          { hl = "MiniStatuslineFileinfo", strings = { yaml_schema, fileinfo } },
          { hl = mode_hl, strings = { location } },
          -- { hl = mode_hl, strings = { "%l:%c%V %P 0x%B" } }, -- remove '0x%B', use :ascii
        })
      end,

      inactive = function()
        local filename = MiniStatusline.section_filename({ trunc_width = 140 })
        return MiniStatusline.combine_groups({
          { hl = "MiniStatuslineDevinfo", strings = { filename } },
        })
      end,
    },
  })
end

return M
