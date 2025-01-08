local blocked_filetypes = { ["neo-tree"] = true }

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

        local lsp_clients = M.section_lsp({ trunc_width = 75 })

        return MiniStatusline.combine_groups({
          { hl = mode_hl, strings = { mode } },
          { hl = "MiniStatuslineDevinfo", strings = { git, diagnostics } },
          "%<", -- Mark general truncate point
          { hl = "MiniStatuslineFilename", strings = { filename } },
          "%=", -- End left alignment
          { hl = "MiniStatuslineModeReplace", strings = { search } },
          { hl = "MiniStatuslineInactive", strings = { lsp_clients } },
          { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
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

  -- Track LSP with autocommands
  M.create_custom_autocommands()
end

M.attached_lsp = {}

M.create_custom_autocommands = function()
  local gr = vim.api.nvim_create_augroup("CustomMiniStatusline", {})

  local au = function(event, pattern, callback, desc)
    vim.api.nvim_create_autocmd(event, { group = gr, pattern = pattern, callback = callback, desc = desc })
  end

  -- Use `schedule_wrap()` because at `LspDetach` server is still present
  local track_lsp = vim.schedule_wrap(function(data)
    M.attached_lsp[data.buf] = M.compute_attached_lsp(data.buf)
    vim.cmd("redrawstatus")
  end)

  au({ "LspAttach", "LspDetach" }, "*", track_lsp, "Track LSP clients")
end

M.compute_attached_lsp = function(buf_id)
  local buf_clients = vim.lsp.buf_get_clients(buf_id)
  if #buf_clients == 0 then return "{}" end

  local unique_buf_client_names = {}
  for _, client in pairs(buf_clients) do
    if not unique_buf_client_names[client.name] then unique_buf_client_names[client.name] = true end
  end

  local client_names = {}
  for key in pairs(unique_buf_client_names) do
    table.insert(client_names, key)
  end

  return "{" .. table.concat(client_names, " ") .. "}"
end

M.section_lsp = function(args)
  if MiniStatusline.is_truncated(args.trunc_width) then return "" end
  return M.attached_lsp[vim.api.nvim_get_current_buf()] or "{}"
end

return M
