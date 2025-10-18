vim.bo.shiftwidth = 2
vim.bo.expandtab = true
vim.bo.cindent = false
vim.wo[0][0].foldmethod = 'indent'
vim.wo[0][0].foldlevel = 99

vim.api.nvim_create_user_command('YamlSchemaSelect', require('aorith.core.yaml_schema').select, {})

vim.api.nvim_create_user_command('YamlSchemaView', function()
  local schema = require('aorith.core.yaml_schema').get_current_schema()
  vim.notify(schema and schema or 'No YAML schema', vim.log.levels.INFO)
end, {})

vim.keymap.set('n', '<localleader>sv', '<cmd>YamlSchemaView<cr>', { buffer = 0, desc = 'YAML Schema View' })
vim.keymap.set('n', '<localleader>ss', '<cmd>YamlSchemaSelect<cr>', { buffer = 0, desc = 'YAML Schema Select' })
-- notify the current schema
-- vim.defer_fn(function() vim.cmd("YAMLSchemaView") end, 3000)

-- Convert yaml to json
local function yaml_to_json_buffer()
  local f = vim.fn.expand('%')
  if f == '' or vim.fn.filereadable(f) == 0 then
    vim.notify('YamlToJson: Buffer must be saved to a file first.', vim.log.levels.ERROR)
    return
  end
  vim.cmd('vnew | set ft=json | r ! yq -o json #')
end
vim.api.nvim_create_user_command('YamlToJson', yaml_to_json_buffer, {})
vim.keymap.set('n', '<localleader>j', '<cmd>YamlToJson<cr>', { buffer = 0, desc = 'YAML to JSON' })
