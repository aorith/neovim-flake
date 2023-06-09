local M = {}

-- directory configuration
M.nvim_appname = vim.fn.getenv("NVIM_APPNAME") ~= vim.NIL and vim.fn.getenv("NVIM_APPNAME") or "nvim"

M.get_active_lsp_clients = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local active_servers = vim.lsp.get_active_clients({ bufnr = bufnr })
  if #active_servers <= 0 then
    return "No LSP servers running."
  end

  local header = "# Active LSP servers\n  "
  local servers = ""
  for _, c in pairs(vim.lsp.get_active_clients({ bufnr = bufnr })) do
    local state = c.initialized and " (running)" or " (starting)"
    servers = servers .. "\n      " .. c.name .. state
  end
  return header .. servers
end

M.show_in_popup = function(text, ft)
  local Popup = require("nui.popup")
  local event = require("nui.utils.autocmd").event

  local popup = Popup({
    buf_options = {
      filetype = ft,
    },
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
    },
    position = "50%",
    size = {
      width = "80%",
      height = "80%",
    },
  })

  -- mount/open the component
  popup:mount()

  -- unmount component when cursor leaves buffer
  popup:on(event.BufLeave, function()
    popup:unmount()
  end)

  local _ = popup:map("n", "q", function()
    popup:unmount()
  end, { noremap = true })

  local lines = {}
  for s in text:gmatch("[^\r\n]+") do
    table.insert(lines, s)
  end
  vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, lines)
end

M.custom_server_capabilities = function()
  local active_clients = vim.lsp.get_active_clients()
  local active_client_map = {}

  for index, value in ipairs(active_clients) do
    active_client_map[value.name] = index
  end

  vim.ui.select(vim.tbl_keys(active_client_map), {
    prompt = "Select client:",
    format_item = function(item)
      return "capabilites for: " .. item
    end,
  }, function(choice)
    if choice == nil then
      return
    end

    -- set content
    local raw_string = vim.inspect(vim.lsp.get_active_clients()[active_client_map[choice]].server_capabilities)
    M.show_in_popup(raw_string, "lua")
  end)
end

function M.get_pyproject_path()
  if vim.loop.fs_stat(vim.fn.getcwd() .. "/pyproject.toml") then
    return vim.fn.getcwd() .. "/pyproject.toml"
  end
  return vim.fn.getenv("XDG_CONFIG_HOME") .. "/" .. M.nvim_appname .. "/lua/plugins/lsp/extras/pyproject.toml"
end

return M
