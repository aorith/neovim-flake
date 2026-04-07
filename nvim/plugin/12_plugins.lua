-------------------------------------------------------------------------------
-- LSP (configuration provided by nvim-lspconfig and/or 'after/lsp/' dir)
-------------------------------------------------------------------------------
vim.lsp.enable({
  'basedpyright',
  'bashls',
  'cssls',
  'cue',
  'gopls',
  'html',
  'jsonnet_ls', -- go install github.com/grafana/jsonnet-language-server@latest
  'lua_ls',
  'marksman',
  'nil_ls', -- nix profile add nixpkgs#nil
  'terraformls',
  'yamlls',
})

-------------------------------------------------------------------------------
-- Treesitter
-------------------------------------------------------------------------------
local languages = {
  'bash',
  'c',
  'cue',
  'diff',
  'go',
  'html',
  'hurl',
  'javascript',
  'jsdoc',
  'json',
  'lua',
  'luadoc',
  'luap',
  'markdown',
  'markdown_inline',
  'nix',
  'printf',
  'python',
  'query',
  'regex',
  'terraform',
  'todotxt',
  'toml',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'xml',
  'yaml',
}

local disabled_files = {
  'Enums.hs',
  'all-packages.nix',
  'hackage-packages.nix',
  'generated.nix',
}

local function disable_treesitter_features(ev)
  if ev.match == 'sh' then return true end
  local short_name = vim.fn.fnamemodify(ev.file, ':t')
  return vim.tbl_contains(disabled_files, short_name)
end

if not Config.on_nix then
  Config.on_packchanged('nvim-treesitter', { 'update' }, function() vim.cmd('TSUpdate') end, ':TSUpdate')

  -- Install missing parsers
  local isnt_installed = function(lang) return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0 end
  local to_install = vim.tbl_filter(isnt_installed, languages)
  if #to_install > 0 then require('nvim-treesitter').install(to_install) end

  require('treesitter-context').setup({
    enable = true,
    max_lines = 3,
    min_window_height = 28,
    multiline_threshold = 3,
    mode = 'topline',
  })
end

-- Start tree-sitter for each installed language's filetypes
local filetypes = {}
for _, lang in ipairs(languages) do
  for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
    table.insert(filetypes, ft)
  end
end

Config.new_autocmd('FileType', filetypes, function(ev)
  if disable_treesitter_features(ev) then
    vim.notify('treesitter disabled for ' .. ev.file, vim.log.levels.DEBUG)
    return
  end

  vim.treesitter.start(ev.buf)

  -- enable ts based folds
  vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  vim.wo.foldmethod = 'expr'
  vim.o.foldlevel = 99

  -- enable ts based indentation
  vim.b.did_indent = 1 -- prevent built-in indent scripts from loading
  vim.bo.indentexpr = 'v:lua.require("nvim-treesitter").indentexpr()'
end, 'Start tree-sitter')

-------------------------------------------------------------------------------
-- Formatting (conform.nvim)
-------------------------------------------------------------------------------
local xdg_config = vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. '/.config')

local function find_stylua_conf()
  local conf_paths = {
    vim.fn.getcwd() .. '/stylua.toml',
    vim.fn.getcwd() .. '/.stylua.toml',
    xdg_config .. '/' .. Config.nvim_appname .. '/stylua.toml',
  }
  for _, v in ipairs(conf_paths) do
    if vim.fn.filereadable(v) == 1 then return { '--config-path', v } end
  end
  return {}
end

require('conform').setup({
  log_level = vim.log.levels.ERROR,
  notify_on_error = true,

  default_format_opts = {
    lsp_format = 'fallback',
    async = false,
    timeout_ms = 2500,
  },

  formatters_by_ft = {
    -- go install mvdan.cc/gofumpt@latest
    -- go install golang.org/x/tools/cmd/goimports@latest
    go = { 'goimports', 'gofumpt' },
    jinja = { 'djlint', lsp_format = 'fallback' },
    htmldjango = { 'djlint', lsp_format = 'fallback' },
    html = { 'prettierd' },
    css = { 'prettierd', lsp_format = 'prefer' },
    scss = { 'prettierd', lsp_format = 'prefer' },
    graphql = { 'prettierd', lsp_format = 'fallback' },
    javascript = { 'prettierd', lsp_format = 'prefer' },
    jsonc = { 'prettierd', lsp_format = 'fallback' },
    markdown = { 'prettierd', lsp_format = 'prefer' },
    typescript = { 'prettierd', lsp_format = 'prefer' },
    yaml = { 'prettierd', 'trim_newlines', lsp_format = 'fallback' }, -- yamlfmt can break yaml blocks (key: |)
    hurl = { 'hurlfmt' },
    json = { 'jq' },
    jsonnet = { 'jsonnetfmt' },
    lua = { 'stylua', lsp_format = 'fallback' },
    nix = { 'nixfmt' },
    python = { 'ruff_format', 'ruff_organize_imports', lsp_format = 'fallback' },
    sh = { 'shfmt' },
    templ = { 'templ', lsp_format = 'fallback' },
    toml = { 'taplo', lsp_format = 'fallback' },
  },

  formatters = {
    yamlfmt = { prepend_args = { '-conf', xdg_config .. '/' .. Config.nvim_appname .. '/extra/yamlfmt' } },
    shfmt = { prepend_args = { '--indent', '4' } },
    ruff = { prepend_args = { '--ignore', 'F841' } },
    stylua = { prepend_args = find_stylua_conf },
    -- Organize imports accounting for local package/module (see gopls config)
    goimports = { command = 'goimports', prepend_args = Config.gopls.goimports_args },
  },
})

-------------------------------------------------------------------------------
-- Linting (nvim-lint)
-------------------------------------------------------------------------------
local lint = require('lint')

lint.linters_by_ft = {
  python = { 'ruff' },
  ansible = { 'ansible_lint' },
  go = { 'golangcilint' },
  htmldjango = { 'djlint' },
  jinja = { 'djlint' },
  nix = { 'nix' },
  terraform = { 'tflint' },
  hcl = { 'tflint' },
  yaml = { 'yamllint' },
  cue = { 'cue' },
}

Config.new_autocmd({ 'BufReadPost', 'BufWritePost', 'InsertLeave' }, nil, function()
  lint.try_lint()
  if vim.bo.filetype ~= 'bigfile' then
    lint.try_lint('typos') -- run typos on all file types
  end
end, 'Lint')

-------------------------------------------------------------------------------
-- Outline (outline.nvim)
-------------------------------------------------------------------------------
require('outline').setup({
  outline_window = { auto_jump = true },

  keymaps = {
    show_help = '?',
    close = { '<Esc>', 'q' },
    goto_location = '<Cr>',
    peek_location = 'o',
    goto_and_close = '<S-Cr>',
    restore_location = '<C-g>',
    hover_symbol = '<C-space>',
    toggle_preview = 'K',
    rename_symbol = 'r',
    code_actions = 'a',
    fold = 'h',
    unfold = 'l',
    fold_toggle = '<Tab>',
    fold_toggle_all = '<S-Tab>',
    fold_all = 'W',
    unfold_all = 'E',
    fold_reset = 'R',
    down_and_jump = '<C-j>',
    up_and_jump = '<C-k>',
  },
})

-------------------------------------------------------------------------------
-- Quicker (quickfix improvements)
-------------------------------------------------------------------------------
require('quicker').setup({
  keys = {
    {
      '>',
      function() require('quicker').expand({ before = 2, after = 2, add_to_existing = true }) end,
      desc = 'Expand quickfix context',
    },
    {
      '<',
      function() require('quicker').collapse() end,
      desc = 'Collapse quickfix context',
    },
  },
})

-------------------------------------------------------------------------------
-- Oil
-------------------------------------------------------------------------------
require('oil').setup({
  delete_to_trash = true,
  watch_for_changes = true,
  keymaps = {
    ['q'] = { 'actions.close', mode = 'n' },
    ['<C-h>'] = false,
    ['<C-l>'] = false,
    ['<C-s>'] = { 'actions.select', opts = { horizontal = true } },
    ['<C-Return>'] = { 'actions.select', opts = { vertical = true } },
  },
})
