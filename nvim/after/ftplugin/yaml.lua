vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true
vim.opt_local.cindent = false
vim.opt_local.foldmethod = "indent"
vim.opt_local.foldlevel = 99

vim.api.nvim_create_user_command("YAMLSchemaSelect", require("aorith.core.yaml_schema").select, {})

vim.api.nvim_create_user_command("YAMLSchemaView", function()
  local schema = require("aorith.core.yaml_schema").get_current_schema()
  vim.notify(vim.inspect(schema), vim.log.levels.INFO)
end, {})

-- notify the current schema
vim.defer_fn(function() vim.cmd("YAMLSchemaView") end, 3000)
