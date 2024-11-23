vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true
vim.opt_local.cindent = false
vim.opt_local.foldmethod = "indent"
vim.opt_local.foldlevel = 99

vim.api.nvim_create_user_command("YamlChangeSchema", function() require("yaml-companion").open_ui_select() end, {})
