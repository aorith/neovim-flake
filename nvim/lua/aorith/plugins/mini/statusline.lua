-- vim.o.winbar = "%#MiniStatuslineFileinfo# %f%( %m%r%) %= "

---@diagnostic disable-next-line: redundant-parameter
require('mini.statusline').setup({
  set_vim_settings = false,
  use_icons = true,

  content = {
    active = function()
      local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 75 })
      -- local git = MiniStatusline.section_git({ trunc_width = 75 })
      -- local diff = MiniStatusline.section_diff({ trunc_width = 75 })
      local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
      -- local lsp = MiniStatusline.section_lsp({ trunc_width = 75 }) -- Shows number of attached lsp servers
      local filename = MiniStatusline.section_filename({ trunc_width = 100 })
      local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
      -- local location = MiniStatusline.section_location({ trunc_width = 75 })
      local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

      if Config.debug_mode then
        mode = 'DEBUG'
        mode_hl = 'MiniStatuslineModeReplace'
      end

      return MiniStatusline.combine_groups({
        { hl = mode_hl, strings = { mode } },
        { hl = 'MiniStatuslineDevinfo', strings = { diagnostics } },
        '%<', -- Mark general truncate point
        { hl = 'MiniStatuslineFilename', strings = { filename } },
        '%=', -- End left alignment
        { hl = 'MiniStatuslineModeReplace', strings = { search } },
        { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
        { hl = mode_hl, strings = { '%02l,%02c %P 0x%02B' } },
      })
    end,

    inactive = function()
      local filename = MiniStatusline.section_filename({ trunc_width = 140 })
      return MiniStatusline.combine_groups({
        { hl = 'MiniStatuslineDevinfo', strings = { filename } },
      })
    end,
  },
})
