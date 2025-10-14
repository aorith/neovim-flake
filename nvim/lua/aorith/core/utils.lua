local M = {}

-- directory configuration
M.nvim_appname = vim.env.NVIM_APPNAME ~= vim.NIL and vim.env.NVIM_APPNAME or "nvim"

M.find_stylua_conf = function()
  local conf_paths = {
    vim.fn.getcwd() .. "/stylua.toml",
    vim.fn.getcwd() .. "/.stylua.toml",
    vim.env.XDG_CONFIG_HOME .. "/" .. M.nvim_appname .. "/stylua.toml",
  }

  for _, v in ipairs(conf_paths) do
    if vim.fn.filereadable(v) == 1 then return { "--config-path", v } end
  end
  return {}
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

return M
