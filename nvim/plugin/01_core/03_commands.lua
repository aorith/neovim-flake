-- Reads the file periodically even if the tmux window is not focused
local function _autoread()
  local timer = vim.uv.new_timer()
  timer:start(
    2000,
    0,
    vim.schedule_wrap(function()
      vim.api.nvim_command("silent! checktime")
      _autoread()
    end)
  )
end
vim.api.nvim_create_user_command("Autoread", function()
  ---@diagnostic disable-next-line: undefined-field
  _autoread()
  vim.notify("Autoread enabled")
end, {})
