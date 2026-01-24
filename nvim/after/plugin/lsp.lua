-- Log level
vim.lsp.set_log_level(vim.log.levels.ERROR)

local custom_on_attach = function(client, bufnr)
  -- notify attachment
  ---@diagnostic disable-next-line: param-type-mismatch
  vim.notify('+ ' .. client.name .. ' started', vim.log.levels.INFO, {
    timeout = 2000,
  })
end

Config.new_autocmd('LspAttach', nil, function(args)
  local client_id = args.data.client_id
  local client = vim.lsp.get_client_by_id(client_id)
  if client then
    custom_on_attach(client, args.buf)
  else
    vim.notify('cannot find client ' .. client_id, vim.log.levels.ERROR)
  end
end, 'Custom On Attach')

vim.lsp.enable({
  'basedpyright',
  'bashls',
  'cssls',
  'cue',
  'eslint',
  'gopls',
  'helm_ls',
  'html',
  'jsonnet_ls', -- go install github.com/grafana/jsonnet-language-server@latest
  'lua_ls',
  'marksman',
  'nil_ls', -- nix profile add nixpkgs#nil
  'rust_analyzer',
  'templ',
  'terraformls',
  'tofu_ls',
  'ts_ls',
  'yamlls',
})
