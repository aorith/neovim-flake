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

Keymap({ 'grd', vim.lsp.buf.definition, desc = 'Definitions' }) -- 'gd' is 'definition in function'
Keymap({ 'grD', vim.lsp.buf.declaration, desc = 'Declaration' }) -- 'gD' is 'definition in file'
--- 'gi' by default is mapped to 'Start Insert where it stopped', so better not remap that
--- 'gra'/'gri'/'grn'/'grr'/'grt'/'gO' are default as of nvim 0.11, see :h lsp-defaults

Leadermap({ 'ls', vim.lsp.buf.signature_help, desc = 'Signature' })

-- Diagnostics ('vim.diagnostic.config()' lives in 'plugin/00_options.lua')
Leadermap({ 'll', vim.diagnostic.open_float, desc = 'Line diagnostics' })
Leadermap({ 'lq', vim.diagnostic.setloclist, desc = 'Set Loc List' })
Leadermap({ 'lj', function() vim.diagnostic.jump({ count = 1, float = true }) end, desc = 'Next diagnostic' })
Leadermap({ 'lk', function() vim.diagnostic.jump({ count = -1, float = true }) end, desc = 'Prev diagnostic' })
Leadermap({ 'xd', vim.diagnostic.setqflist, desc = 'Diagnostics to Quickfix' })
Leadermap({
  'td',
  function()
    local is_enabled = vim.diagnostic.is_enabled({ bufnr = 0 })
    vim.diagnostic.enable(not is_enabled, { bufnr = 0 })
    print(is_enabled and 'nodiagnostic' or '  diagnostic')
  end,
  desc = 'Toggle diagnostic',
})
