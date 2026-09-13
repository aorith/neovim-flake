-------------------------------------------------------------------------------
-- Modules with little or no configuration
-------------------------------------------------------------------------------
require('mini.misc').setup({
  make_global = { 'put', 'put_text' },
})
MiniMisc.setup_restore_cursor()

require('mini.tabline').setup()
require('mini.statuscolumn').setup()
require('mini.cmdline').setup({
  autocomplete = { delay = 300 },
  autocorrect = { enable = false },
  autopeek = { enable = false },
})
require('mini.extra').setup()
require('mini.input').setup()

require('mini.icons').setup()
require('mini.icons').mock_nvim_web_devicons()
require('mini.icons').tweak_lsp_kind()

require('mini.bufremove').setup()

-- [b/]b buffer, [q/]q quickfix, [d/]d diagnostic, [w/]w window, [y/]y yank, etc. See `:h mini.bracketed`
require('mini.bracketed').setup()

-- sa => surround around
-- sd => surround delete
-- sr => surround replace
-- Example: Visual select a word -> sa"  (surround around quotes, 'saq' with mini.ai)
require('mini.surround').setup()

require('mini.trailspace').setup({ only_in_normal_buffers = true })
require('mini.jump').setup({ delay = { highlight = 50 } })
-- Press CR to start jumping
require('mini.jump2d').setup({
  labels = 'jkldefghiancmbopqrstu1234vwxyz',
  allowed_lines = { blank = false, cursor_at = false, fold = false },
  silent = true,
})

Leadermap({ 'q', function() require('mini.bufremove').delete() end, desc = 'Delete current buffer' })
Leadermap({ 'z', function() require('mini.misc').zoom() end, desc = 'Zoom window' })

-------------------------------------------------------------------------------
-- mini.ai
-------------------------------------------------------------------------------
-- Enables 'ciq' (change inside quotes) or 'cib' (change inside brackets), etc.
local ai = require('mini.ai')
ai.setup({
  custom_textobjects = {
    -- 'aB'/'iB' => whole buffer
    B = MiniExtra.gen_ai_spec.buffer(),
    -- 'aF'/'iF' => function definition, 'aC'/'iC' => class (tree-sitter based,
    -- queries come from 'nvim-treesitter-textobjects')
    F = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
    C = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),
  },
  -- Only act on the textobject covering the cursor; use 'an'/'in' or 'al'/'il'
  -- to explicitly target the next/last one
  search_method = 'cover',
})

-------------------------------------------------------------------------------
-- mini.clue
-------------------------------------------------------------------------------
local miniclue = require('mini.clue')

miniclue.setup({
  window = { delay = 200, config = { width = 'auto' } },

  triggers = {
    { mode = 'n', keys = '<Leader>' },
    { mode = 'x', keys = '<Leader>' },
    { mode = 'n', keys = '<LocalLeader>' },
    { mode = 'x', keys = '<LocalLeader>' },
    { mode = 'n', keys = '\\' }, -- LocalLeader
    { mode = 'n', keys = '[' }, -- mini.bracketed
    { mode = 'n', keys = ']' },
    { mode = 'x', keys = '[' },
    { mode = 'x', keys = ']' },
    { mode = 'i', keys = '<C-x>' }, -- Built-in completion
    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },
    { mode = 'n', keys = "'" }, -- Marks
    { mode = 'n', keys = '`' },
    { mode = 'x', keys = "'" },
    { mode = 'x', keys = '`' },
    { mode = 'n', keys = '"' }, -- Registers
    { mode = 'x', keys = '"' },
    { mode = 'i', keys = '<C-r>' },
    { mode = 'c', keys = '<C-r>' },
    { mode = 'n', keys = '<C-w>' }, -- Window commands
    { mode = 'n', keys = 'z' },
    { mode = 'x', keys = 'z' },
  },

  clues = {
    { mode = 'n', keys = '<leader>b', desc = '+Buffer' },
    { mode = 'n', keys = '<leader>f', desc = '+Find' },
    { mode = 'n', keys = '<leader>g', desc = '+Git' },
    { mode = 'x', keys = '<leader>g', desc = '+Git' },
    { mode = 'n', keys = '<leader>l', desc = '+LSP' },
    { mode = 'n', keys = '<leader>n', desc = '+Notes' },
    { mode = 'n', keys = '<leader>w', desc = '+Window' },
    { mode = 'n', keys = '<leader>x', desc = '+Quickfix' },
    { mode = 'n', keys = '<leader>t', desc = '+Toggle' },
    { mode = 'n', keys = '<Leader>h', desc = '+Harpoon' },

    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  },
})

-------------------------------------------------------------------------------
-- mini.hipatterns
-------------------------------------------------------------------------------
local hipatterns = require('mini.hipatterns')

hipatterns.setup({
  highlighters = {
    -- Highlight standalone 'FIX', 'FIXME', 'HACK', 'TODO', 'NOTE'
    fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
    fix = { pattern = '%f[%w]()FIX()%f[%W]', group = 'MiniHipatternsFixme' },
    hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
    todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
    note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

    -- Highlight hex color strings (#rrggbb) using that color: #992233, #229933, #223399
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})

-------------------------------------------------------------------------------
-- mini.indentscope
-------------------------------------------------------------------------------
local indentscope = require('mini.indentscope')
indentscope.setup({
  draw = {
    animation = indentscope.gen_animation.none(),
  },
})

NewAutocmd('mini-indent-disable', nil, 'FileType', {
  'NvimTree',
  'bigfile',
  'dashboard',
  'help',
  'man',
  'minipick',
  'notify',
  'oil',
}, function() vim.b.miniindentscope_disable = true end, 'Disable mini indent scope')

-------------------------------------------------------------------------------
-- mini.notify
-------------------------------------------------------------------------------
require('mini.notify').setup({
  lsp_progress = { enable = false },
})

vim.notify = require('mini.notify').make_notify()
vim.api.nvim_create_user_command('Notifications', function() require('mini.notify').show_history() end, {})
