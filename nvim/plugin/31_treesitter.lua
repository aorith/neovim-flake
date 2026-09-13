local languages = {
  'bash',
  'c',
  'css',
  'cue',
  'diff',
  'go',
  'html',
  'htmldjango',
  'hurl',
  'javascript',
  'jinja',
  'jsdoc',
  'json',
  'jsonnet',
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
  'rust',
  'scss',
  'templ',
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
  OnPackChanged('nvim-treesitter', { 'update' }, function() vim.cmd('TSUpdate') end, ':TSUpdate')

  -- Install missing parsers
  local isnt_installed = function(lang) return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0 end
  local to_install = vim.tbl_filter(isnt_installed, languages)
  if #to_install > 0 then require('nvim-treesitter').install(to_install) end
end

-- Start tree-sitter for each installed language's filetypes
local filetypes = {}
for _, lang in ipairs(languages) do
  for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
    table.insert(filetypes, ft)
  end
end

NewAutocmd('ts-disable', nil, 'FileType', filetypes, function(ev)
  if disable_treesitter_features(ev) then
    vim.notify('treesitter disabled for ' .. ev.file, vim.log.levels.DEBUG)
    return
  end

  vim.treesitter.start(ev.buf)

  -- Enable ts based folds. `vim.wo[0][0]` scopes them to this buffer, otherwise
  -- they stay behind in the window when another buffer is loaded into it.
  vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  vim.wo[0][0].foldmethod = 'expr'

  -- enable ts based indentation only for some fts
  if vim.tbl_contains({ 'python' }, ev.match) then
    vim.b.did_indent = 1 -- prevent built-in indent scripts from loading
    vim.bo.indentexpr = 'v:lua.require("nvim-treesitter").indentexpr()'
  end
end, 'Start tree-sitter')

-------------------------------------------------------------------------------
-- treesitter-context
-------------------------------------------------------------------------------
-- On Nix this plugin comes from 'nix/plugins.nix', so it is configured outside
-- of the `on_nix` guard above
require('treesitter-context').setup({
  enable = true,
  max_lines = 3,
  min_window_height = 28,
  multiline_threshold = 3,
  mode = 'topline',
})

Leadermap({
  'tx',
  function()
    local ctx = require('treesitter-context')
    ctx.toggle()
    print(ctx.enabled() and '  tscontext' or 'notscontext')
  end,
  desc = 'Toggle context',
})
