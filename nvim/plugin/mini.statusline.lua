local blocked_filetypes = { ["neo-tree"] = true }

require("mini.tabline").setup({})

require("mini.statusline").setup({
  set_vim_settings = false,
  use_icons = true,

  content = {
    active = function()
      if blocked_filetypes[vim.bo.filetype] then return "" end

      local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 1024 })
      local git = MiniStatusline.section_git({ trunc_width = 75 })
      local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
      local filename = MiniStatusline.section_filename({ trunc_width = 140 })
      local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })

      return MiniStatusline.combine_groups({
        { hl = mode_hl, strings = { mode } },
        { hl = "MiniStatuslineDevinfo", strings = { git } },
        "%<", -- Mark general truncate point
        { hl = "MiniStatuslineFilename", strings = { filename } },
        { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
        { hl = "MiniStatuslineDevinfo", strings = { diagnostics } },
        "%=", -- End left alignment
        { hl = "MiniStatuslineFilename", strings = { "%l:%c%V %P 0x%B" } },
      })
    end,

    inactive = function()
      local filename = MiniStatusline.section_filename({ trunc_width = 140 })
      return MiniStatusline.combine_groups({
        { hl = "MiniStatuslineFilename", strings = { filename } },
      })
    end,
  },
})
