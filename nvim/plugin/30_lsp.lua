vim.lsp.log.set_level(vim.log.levels.ERROR)

-- Server configuration is provided by nvim-lspconfig and/or the 'after/lsp/' dir.
-- Completion/signature capabilities are advertised in 'plugin/21_mini_completion.lua'.
vim.lsp.enable({
  'ansiblels', -- pipx install ansible-lint && npm i -g @ansible/ansible-language-server
  'basedpyright',
  'bashls',
  'clangd',
  'cssls',
  'cue',
  'gopls',
  'html',
  'jsonnet_ls', -- go install github.com/grafana/jsonnet-language-server@latest
  'lua_ls',
  'marksman',
  'nil_ls', -- nix profile add nixpkgs#nil
  'rust_analyzer',
  'taplo', -- same binary already used as the toml formatter
  'templ', -- go install github.com/a-h/templ/cmd/templ@latest
  'terraformls',
  'ts_ls', -- npm i -g typescript typescript-language-server
  'yamlls',
})

Keys.map('n', 'grd', vim.lsp.buf.definition, 'Definitions') -- 'gd' is 'definition in function'
Keys.map('n', 'grD', vim.lsp.buf.declaration, 'Declaration') -- 'gD' is 'definition in file'
--- 'gi' by default is mapped to 'Start Insert where it stopped', so better not remap that
--- 'gra'/'gri'/'grn'/'grr'/'grt'/'gO' are default as of nvim 0.11, see :h lsp-defaults

Keys.map_leader('n', 'ls', vim.lsp.buf.signature_help, 'Signature')

-- Diagnostics ('vim.diagnostic.config()' lives in 'plugin/00_options.lua')
Keys.map_leader('n', 'll', vim.diagnostic.open_float, 'Line diagnostics')
Keys.map_leader('n', 'lq', vim.diagnostic.setloclist, 'Set Loc List')
Keys.map_leader('n', 'lj', function() vim.diagnostic.jump({ count = 1, float = true }) end, 'Next diagnostic')
Keys.map_leader('n', 'lk', function() vim.diagnostic.jump({ count = -1, float = true }) end, 'Prev diagnostic')
Keys.map_leader('n', 'xd', vim.diagnostic.setqflist, 'Diagnostics to Quickfix')
Keys.map_leader('n', 'td', function()
  local is_enabled = vim.diagnostic.is_enabled({ bufnr = 0 })
  vim.diagnostic.enable(not is_enabled, { bufnr = 0 })
  print(is_enabled and 'nodiagnostic' or '  diagnostic')
end, 'Toggle diagnostic')
