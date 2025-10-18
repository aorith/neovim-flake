vim.bo.formatexpr = ''
vim.bo.formatprg = 'jq'

-- Convert json to yaml
local function json_to_yaml_buffer()
  local f = vim.fn.expand('%')
  if f == '' or vim.fn.filereadable(f) == 0 then
    vim.notify('JsonToYaml: Buffer must be saved to a file first.', vim.log.levels.ERROR)
    return
  end
  vim.cmd('vnew | set ft=yaml | r ! yq -o yaml #')
end
vim.api.nvim_create_user_command('JsonToYaml', json_to_yaml_buffer, {})
vim.keymap.set('n', '<localleader>j', '<cmd>JsonToYaml<cr>', { buffer = 0, desc = 'JSON to YAML' })
