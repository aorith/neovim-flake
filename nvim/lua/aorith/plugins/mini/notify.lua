---@diagnostic disable-next-line: redundant-parameter
require("mini.notify").setup({
  content = {
    -- do not append time to the notification
    format = function(notif) return notif.msg end,
  },
  window = { winblend = 0 },
})

vim.notify = require("mini.notify").make_notify()
vim.api.nvim_create_user_command("Notifications", function() require("mini.notify").show_history() end, {})
