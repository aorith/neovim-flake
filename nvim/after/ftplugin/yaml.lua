vim.bo.shiftwidth = 2
vim.bo.expandtab = true
vim.bo.cindent = false
vim.wo[0][0].foldmethod = 'indent'
vim.wo[0][0].foldlevel = 99

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
