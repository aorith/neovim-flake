-------------------------------------------------------------------------------
-- Core
-------------------------------------------------------------------------------
require('mini.tabline').setup()
require('mini.extra').setup()
require('mini.diff').setup()
require('mini.misc').setup({ make_global = { 'put', 'put_text' } })

require('mini.icons').setup()
require('mini.icons').mock_nvim_web_devicons()
require('mini.icons').tweak_lsp_kind()

require('mini.ai').setup() -- Enables 'ciq' (change inside quotes) or 'cib' (change inside brackets), etc.
require('mini.bufremove').setup()

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

-------------------------------------------------------------------------------
-- Statusline
-------------------------------------------------------------------------------
require('mini.statusline').setup({
  set_vim_settings = false,
  use_icons = true,

  content = {
    active = function()
      -- local mode, hl_group = MiniStatusline.section_mode({ trunc_width = 1000 })
      -- local git         = MiniStatusline.section_git({ trunc_width = 75 })
      -- local diff        = MiniStatusline.section_diff({ trunc_width = 75 })
      -- local lsp         = MiniStatusline.section_lsp({ trunc_width = 75 })
      -- local fileinfo    = MiniStatusline.section_fileinfo({ trunc_width = 120 })
      -- local location    = MiniStatusline.section_location({ trunc_width = 75 })
      local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
      local filename = MiniStatusline.section_filename({ trunc_width = 100 })
      local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

      return MiniStatusline.combine_groups({
        '%<', -- Mark general truncate point
        { hl = 'StatusLine', strings = { filename, diagnostics } },
        '%=', -- End left alignment
        { strings = { search } },
        { strings = { '%y %02l,%02c %P 0x%02B' } },
      })
    end,

    inactive = function()
      local filename = MiniStatusline.section_filename({ trunc_width = 140 })
      return MiniStatusline.combine_groups({
        { hl = 'StatusLineNC', strings = { filename } },
      })
    end,
  },
})

-------------------------------------------------------------------------------
-- Mini clue
-------------------------------------------------------------------------------
local miniclue = require('mini.clue')

miniclue.setup({
  window = { delay = 200, config = { width = 'auto' } },

  triggers = {
    { mode = 'n', keys = '<Leader>' },
    { mode = 'x', keys = '<Leader>' },
    { mode = 'n', keys = '<LocalLeader>' },
    { mode = 'x', keys = '<LocalLeader>' },
    { mode = 'n', keys = '\\' }, -- mini.basics
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
-- Completion (mini.completion, mini.keymap, mini.snippets)
-------------------------------------------------------------------------------
-- Don't show 'Text' suggestions (usually noisy) and show snippets last.
local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }
local process_items = function(items, base) return MiniCompletion.default_process_items(items, base, process_items_opts) end

require('mini.completion').setup({
  lsp_completion = {
    source_func = 'omnifunc',
    auto_setup = false,
    process_items = process_items,
  },
})

Config.new_autocmd('LspAttach', nil, function(args)
  vim.bo[args.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'

  local client = vim.lsp.get_client_by_id(args.data.client_id)
  if client then
    vim.notify('+ ' .. client.name .. ' started', vim.log.levels.INFO, { timeout = 2000 })
  else
    vim.notify('cannot find client ' .. args.data.client_id, vim.log.levels.ERROR)
  end
end, 'LSP on-attach')

-- Advertise completion/signature capabilities to servers.
vim.lsp.config('*', { capabilities = MiniCompletion.get_lsp_capabilities() })

require('mini.keymap').setup()
MiniKeymap.map_multistep('i', '<Tab>', { 'pmenu_next' })
MiniKeymap.map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
MiniKeymap.map_multistep('i', '<CR>', { 'pmenu_accept' })

local gen_loader = require('mini.snippets').gen_loader
require('mini.snippets').setup({
  snippets = {
    gen_loader.from_lang(),
  },
})

-- Stop all sessions on Normal mode exit
local make_stop = function()
  local au_opts = { pattern = '*:n', once = true }
  au_opts.callback = function()
    while MiniSnippets.session.get() do
      MiniSnippets.session.stop()
    end
  end
  vim.api.nvim_create_autocmd('ModeChanged', au_opts)
end
Config.new_autocmd('User', 'MiniSnippetsSessionStart', make_stop, 'Stop all snippet sessions on Normal mode exit')

-------------------------------------------------------------------------------
-- Mini git
-------------------------------------------------------------------------------
local MiniGit = require('mini.git')
MiniGit.setup({ command = { split = 'vertical' } })

local align_blame = function(au_data)
  if au_data.data.git_subcommand ~= 'blame' then return end

  -- Align blame output with source
  local win_src = au_data.data.win_source
  vim.wo.wrap = false
  vim.fn.winrestview({ topline = vim.fn.line('w0', win_src) })
  vim.api.nvim_win_set_cursor(0, { vim.fn.line('.', win_src), 0 })

  -- Bind both windows so that they scroll together
  vim.wo[win_src].scrollbind, vim.wo.scrollbind = true, true
end

local au_opts = { pattern = 'MiniGitCommandSplit', callback = align_blame }
vim.api.nvim_create_autocmd('User', au_opts)

-------------------------------------------------------------------------------
-- Mini hipatterns
-------------------------------------------------------------------------------
local hipatterns = require('mini.hipatterns')

hipatterns.setup({
  highlighters = {
    delay = {
      text_change = 600,
      scroll = 200,
    },

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
-- Mini indentscope
-------------------------------------------------------------------------------
require('mini.indentscope').setup({
  draw = {
    animation = require('mini.indentscope').gen_animation.none(),
  },
})

Config.new_autocmd('FileType', {
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
-- Mini notify
-------------------------------------------------------------------------------
require('mini.notify').setup({
  content = {
    -- Do not append timestamp to notifications
    format = function(notif) return notif.msg end,
  },
  window = { winblend = 0 },
})

vim.notify = require('mini.notify').make_notify()
vim.api.nvim_create_user_command('Notifications', function() require('mini.notify').show_history() end, {})

-------------------------------------------------------------------------------
-- Mini pick
-------------------------------------------------------------------------------
require('mini.pick').setup({
  window = { config = { width = vim.o.columns } },

  mappings = {
    choose = '<CR>',
    choose_in_split = '<C-s>',
    choose_in_vsplit = '<C-v>',
    choose_in_tabpage = '<C-t>',
    choose_marked = '<C-q>',
    mark = '<C-x>',
    mark_all = '<C-a>',
  },
})

vim.ui.select = MiniPick.ui_select

-- Pick files from arglist (used as a Harpoon-style file list)
MiniPick.registry.harpoon = function()
  local items = vim.fn.argv() --[[@as string[] ]]

  local picker_items = {}
  for i, arg in ipairs(items) do
    table.insert(picker_items, {
      text = string.format('%d: %s', i, arg),
      path = arg,
      arg_index = i,
    })
  end

  local choose = function(item)
    local win_id = MiniPick.get_picker_state().windows.target
    vim.api.nvim_win_call(win_id, function() vim.cmd(item.arg_index .. 'argument') end)
  end

  return MiniPick.start({ source = { items = picker_items, name = 'Harpoon', choose = choose } })
end
