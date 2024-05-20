-- Commands
vim.cmd("command! CheckLspServerCapabilities :lua =require('aorith.core.utils').custom_server_capabilities()")
vim.cmd("command! DownloadSpellFiles :lua =require('aorith.core.utils').download_spell_files()")
vim.cmd("command! GetActiveLSPClients :lua =require('aorith.core.utils').get_active_lsp_clients()")

local M = {}

-- directory configuration
M.nvim_appname = vim.fn.getenv("NVIM_APPNAME") ~= vim.NIL and vim.fn.getenv("NVIM_APPNAME") or "nvim"

M.find_stylua_conf = function()
  local conf_paths = {
    vim.fn.getcwd() .. "/stylua.toml",
    vim.fn.getcwd() .. "/.stylua.toml",
    vim.fn.getenv("XDG_CONFIG_HOME") .. "/" .. M.nvim_appname .. "/stylua.toml",
  }

  for _, v in ipairs(conf_paths) do
    if vim.fn.filereadable(v) == 1 then return { "--config-path", v } end
  end
  return {}
end

M.get_active_lsp_clients = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local active_servers = vim.lsp.get_clients({ bufnr = bufnr })
  if #active_servers <= 0 then return "No LSP servers running." end

  local header = "# Active LSP servers\n"
  local servers = ""
  for _, c in pairs(active_servers) do
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
  popup:on(event.BufLeave, function() popup:unmount() end)

  local _ = popup:map("n", "q", function() popup:unmount() end, { noremap = true })

  local lines = {}
  for s in text:gmatch("[^\r\n]+") do
    table.insert(lines, s)
  end
  vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, lines)
end

M.custom_server_capabilities = function()
  local active_clients = vim.lsp.get_clients()
  local active_client_map = {}

  for index, value in ipairs(active_clients) do
    active_client_map[value.name] = index
  end

  vim.ui.select(vim.tbl_keys(active_client_map), {
    prompt = "Select client:",
    format_item = function(item) return "capabilities for: " .. item end,
  }, function(choice)
    if choice == nil then return end

    -- set content
    local raw_string = vim.inspect(vim.lsp.get_clients()[active_client_map[choice]].server_capabilities)
    M.show_in_popup(raw_string, "lua")
  end)
end

-- Inserts a new empty code block below the current line
M.markdown_insert_codeblock = function()
  local win = vim.api.nvim_get_current_win()
  local row, _ = unpack(vim.api.nvim_win_get_cursor(win))

  -- Insert the text in a new line below the current line
  vim.api.nvim_buf_set_lines(0, row, row, false, { "```", "```" })

  local newRow = row + 1 -- Move cursor down one line
  local newCol = 4

  vim.api.nvim_win_set_cursor(win, { newRow, newCol })
end

-- Navigate between links / headers
M.markdown_next_link = function()
  if vim.fn.search("\\(](.\\+)\\|^#\\+ .\\+\\|\\[\\[.\\+]]\\)", "w") ~= 0 then
    vim.cmd("norm w")
  else
    vim.notify("No markdown headers or links found.")
  end
end
M.markdown_prev_link = function()
  if vim.fn.search("\\(](.\\+)\\|^#\\+ .\\+\\|\\[\\[.\\+]]\\)", "b") ~= 0 then
    -- I have to search twice backwards because the cursor is moved
    -- with 'w' and the backward search finds the same item
    vim.fn.search("\\(](.\\+)\\|^#\\+ .\\+\\|\\[\\[.\\+]]\\)", "b")
    vim.cmd("norm w")
  else
    vim.notify("No markdown headers or links found.")
  end
end

-- Toggle To-Dos
M.markdown_todo_toggle = function()
  -- In lua '%' are escape chars
  if string.match(vim.api.nvim_get_current_line(), "- %[ %] ") ~= nil then
    vim.cmd([[
      s/- \[ \] /- \[x\] /g
      nohl
    ]])
  elseif string.match(vim.api.nvim_get_current_line(), "- %[[xX]%] ") ~= nil then
    vim.cmd([[
      s/- \[[xX]\] /- \[ \] /g
      nohl
      ]])
  end
end

-- Download spellang files
local function ensure_spell_file(lang)
  local spell_dir = vim.fn.stdpath("data") .. "/site/spell"
  vim.fn.mkdir(spell_dir, "p")
  local spell_file = spell_dir .. "/" .. lang .. ".spl"

  local url = "http://ftp.vim.org/pub/vim/runtime/spell/" .. lang .. ".spl"
  local command = "curl --fail -L -s -o " .. spell_file .. " " .. url
  os.execute(command)
  vim.notify("Downloaded " .. lang .. " spell file")
end
M.download_spell_files = function()
  ensure_spell_file("en.utf-8")
  ensure_spell_file("es.utf-8")
end

return M
