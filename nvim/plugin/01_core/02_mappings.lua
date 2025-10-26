local map = vim.keymap.set

-- Create `<Leader>` mappings
local nmap_leader = function(suffix, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set('n', '<Leader>' .. suffix, rhs, opts)
end
local xmap_leader = function(suffix, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set('x', '<Leader>' .. suffix, rhs, opts)
end

-- Copy to primary selection on select
map('v', '<LeftRelease>', '"*ygv')

-- Misc
map('n', 'x', '"_x', { desc = "Avoid 'x' copying to the register" })
map('v', '<leader>y', '"+y', { remap = true, desc = 'Copy to the system clipboard' })
map('n', '<leader>y', '"+yy', { remap = true, desc = 'Copy to the system clipboard' })

-- Moves lines
map('v', 'J', ":m '>+1<CR>gv=gv")
map('v', 'K', ":m '<-2<CR>gv=gv")

-- Navigate wrapped lines
map('n', 'j', 'gj')
map('n', 'k', 'gk')

-- Center view on search
map('n', 'n', 'nzz')
map('n', 'N', 'Nzz')

-- Move to window using the <ctrl> hjkl keys
map('n', '<C-h>', '<C-w>h', { desc = 'Go to left window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Go to right window' })
-- Resize window using <ctrl> arrow keys
map('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
map('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
map('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
map('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })

-- Clear search with <esc>
map({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })

-- Don't reset indent on '#', see :h smartindent
map('i', '#', 'X#')

-- Get highlight group under cursor
map('n', '<C-e>', function()
  local result = vim.treesitter.get_captures_at_cursor(0)
  print(vim.inspect(result))
end, { desc = 'highlight group under cursor' })

map('n', '<leader>xl', '<cmd>lopen<cr>', { desc = 'Location List' })
map('n', '<leader>xq', '<cmd>copen<cr>', { desc = 'Quickfix List' })

-- buffers
map('n', '<leader><TAB>', '<cmd>bnext<CR>', { silent = true, desc = 'Next buffer' })
map('n', '<leader>ba', '<cmd>b#<cr>', { desc = 'Alternate buffer' })
map('n', '<leader>bd', '<Cmd>lua MiniBufremove.delete()<CR>', { desc = 'Delete' })
map('n', '<leader>bD', '<Cmd>lua MiniBufremove.delete(0, true)<CR>', { desc = 'Delete!' })
map('n', '<leader>bw', '<Cmd>lua MiniBufremove.wipeout()<CR>', { desc = 'Wipeout' })
map('n', '<leader>bW', '<Cmd>lua MiniBufremove.wipeout(0, true)<CR>', { desc = 'Wipeout!' })
map('n', '<leader>bb', function()
  local curbufnr = vim.api.nvim_get_current_buf()
  local bufinfo
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if bufnr ~= curbufnr and vim.api.nvim_get_option_value('modified', { buf = bufnr }) == false then
      bufinfo = vim.fn.getbufinfo(bufnr)[1]
      if bufinfo.loaded == 1 and bufinfo.listed == 1 then vim.cmd('bd! ' .. tostring(bufnr)) end
    end
  end
end, { desc = 'Close all other unmodified buffers' })

-- windows
map('n', '<leader>w', '<C-W>c', { desc = 'Delete window' })
map('n', '<leader>-', '<C-W>s', { desc = 'Split window below' })
map('n', '<leader>|', '<C-W>v', { desc = 'Split window right' })

-- others
map('', '<F1>', '<nop>') -- "" == map
map('!', '<F1>', '<nop>') -- "!" == map!
vim.api.nvim_create_user_command('W', 'w', { bang = true })
vim.api.nvim_create_user_command('Q', 'q', { bang = true })

-- terminal
map('t', '<Esc>', '<C-\\><C-n>', { desc = 'Go to normal mode' })

-- quick fix
map('n', '<leader>j', '<cmd>cnext<CR>', { desc = 'Next item in QuickFix' })
map('n', '<leader>k', '<cmd>cprevious<CR>', { desc = 'Previous item in QuickFix' })

-- diagnostics
map('n', '<leader>ll', vim.diagnostic.open_float, { desc = 'Line diagnostics' })
map('n', '<leader>lq', vim.diagnostic.setloclist, { desc = 'Set Loc List' })
map('n', '<leader>lj', function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = 'Next diagnostic' })
map('n', '<leader>lk', function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = 'Prev diagnostic' })

map('n', '<leader>lc', vim.lsp.buf.code_action, { desc = 'Code actions' })
map('n', '<leader>lr', vim.lsp.buf.rename, { desc = 'Rename' })
map('n', '<leader>ls', vim.lsp.buf.signature_help, { desc = 'Signature' })

nmap_leader('<leader>', function()
  MiniPick.builtin.buffers({ include_current = false }, {
    mappings = {
      wipeout = {
        char = '<C-d>',
        func = function() vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {}) end,
      },
    },
  })
end, 'Buffers')
nmap_leader('bm', "<Cmd>Pick marks scope='global'<CR>", 'Global Marks')
nmap_leader('ff', '<Cmd>Pick files<CR>', 'Files')
nmap_leader('fg', '<Cmd>Pick grep_live<CR>', 'Grep live')
nmap_leader('fl', '<Cmd>Pick buf_lines scope="current"<CR>', 'Lines (current)')
nmap_leader('fL', '<Cmd>Pick buf_lines scope="all"<CR>', 'Lines (all)')
nmap_leader('fd', '<Cmd>Pick diagnostic scope="current"<CR>', 'Diagnostic buffer')
nmap_leader('fD', '<Cmd>Pick diagnostic scope="all"<CR>', 'Diagnostic workspace')
nmap_leader('fa', '<Cmd>Pick git_hunks scope="staged"<CR>', 'Added hunks (all)')
nmap_leader('fA', '<Cmd>Pick git_hunks path="%" scope="staged"<CR>', 'Added hunks (buf)')
nmap_leader('fm', '<Cmd>Pick git_hunks path="%:p" n_context=0<CR>', 'Modified hunks (current)')
nmap_leader('fM', '<Cmd>Pick git_hunks<CR>', 'Modified hunks (all)')
nmap_leader('fr', '<Cmd>Pick resume<CR>', 'Resume')
nmap_leader('fR', '<Cmd>Pick lsp scope="references"<CR>', 'References (LSP)')
nmap_leader('fs', '<Cmd>Pick lsp scope="document_symbol"<CR>', 'Symbols buffer (LSP)')
nmap_leader('fS', '<Cmd>Pick lsp scope="workspace_symbol"<CR>', 'Symbols workspace (LSP)')
nmap_leader('fh', '<Cmd>Pick help<CR>', 'Help tags')
nmap_leader('fH', '<Cmd>Pick hl_groups<CR>', 'Highlight groups')
nmap_leader('fp', '<Cmd>Pick spellsuggest<CR>', 'Spell suggest')
nmap_leader('fk', '<Cmd>Pick keymaps<CR>', 'Keymaps')
nmap_leader('fc', '<Cmd>Pick git_commits path="%:p"<CR>', 'Commits (current)')
nmap_leader('fC', '<Cmd>Pick git_commits<CR>', 'Commits (all)')
nmap_leader('fv', '<Cmd>Pick visit_paths<CR>', 'Visit paths (cwd)')
nmap_leader('fV', '<Cmd>Pick visit_paths cwd=""<CR>', 'Visit paths (all)')

local git_log_cmd = [[Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order]]
local git_reflog_cmd = [[Git log --abbrev-commit --walk-reflogs --pretty=format:\%h\ \%ai\ \%al\ |\ \%s\ |\ \%d]] -- similar to 'git reflog'
local git_graph_cmd = [[Git log --graph --all --pretty=format:\%h\ \%ai\ \%al\ |\ \%s\ |\ \%d]]
nmap_leader('ga', '<Cmd>Git diff --cached -- %:p<CR>', 'Added diff buffer')
nmap_leader('gA', '<Cmd>Git diff --cached<CR>', 'Added diff')
nmap_leader('gd', '<Cmd>Git diff -- %:p<CR>', 'Diff buffer')
nmap_leader('gD', '<Cmd>Git diff<CR>', 'Diff')
nmap_leader('gb', '<Cmd>Git blame -- %:p<CR>', 'Blame buffer')
nmap_leader('gl', '<Cmd>' .. git_log_cmd .. ' --follow -- %:p<CR>', 'Log buffer')
nmap_leader('gL', '<Cmd>' .. git_log_cmd .. '<CR>', 'Log')
nmap_leader('gr', '<Cmd>tab ' .. git_reflog_cmd .. '<CR>', 'Reflog')
nmap_leader('gg', '<Cmd>tab ' .. git_graph_cmd .. '<CR>', 'Graph')
nmap_leader('go', '<Cmd>lua MiniDiff.toggle_overlay()<CR>', 'Toggle diff overlay')
nmap_leader('gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>', 'Show at cursor')

xmap_leader('gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>', 'Show at selection') -- Show at cursor already gives info from show_range_history
xmap_leader(
  'gb',
  function() vim.cmd('Git log -L ' .. vim.fn.line("'<") .. ',' .. vim.fn.line("'>") .. ':' .. vim.fn.expand('%:p')) end,
  'Blame selection'
)

-- LSP
map('n', 'grd', vim.lsp.buf.definition, { desc = 'Definitions' }) -- 'gd' is 'definition in function'
map('n', 'grD', vim.lsp.buf.declaration, { desc = 'Declaration' }) -- 'gD' is 'definition in file'
--- 'gi' by default is mapped to 'Start Insert where it stopped', so better not remap that
--- 'gr' prefix is default as of nvim 0.11
map('n', 'gri', vim.lsp.buf.implementation, { desc = 'Implementation' })
map('n', 'grr', vim.lsp.buf.references, { desc = 'References' })
map('n', 'grn', vim.lsp.buf.rename, { desc = 'Rename' })
map('n', 'grt', vim.lsp.buf.type_definition, { desc = 'Type Definitions' })

-- Formatting
nmap_leader(
  'lf',
  function() require('conform').format({ lsp_format = 'fallback', async = false, timeout_ms = 2500 }) end,
  'Format buffer'
)
xmap_leader(
  'lf',
  function() require('conform').format({ lsp_format = 'fallback', async = false, timeout_ms = 2500 }) end,
  'Format buffer'
)

-- Outline
nmap_leader('a', '<cmd>Outline<CR>', 'Toggle outline')

-- Mini.files
map('n', '-', function()
  local mf = require('mini.files')
  local currFile = vim.api.nvim_buf_get_name(0)
  if vim.uv.fs_stat(currFile) == nil then
    mf.open(nil, false)
  else
    mf.open(currFile, false)
  end
end, { desc = 'Open parent directory' })

nmap_leader('e', function() require('mini.files').open(nil, false) end, 'MiniFiles')

-- Toggles (most of them are setup with 'mini.basics')
nmap_leader('tx', function()
  local ctx = require('treesitter-context')
  ctx.toggle()
  if ctx.enabled() then
    vim.notify('Context enabled')
  else
    vim.notify('Context disabled')
  end
end, 'Toggle context')

-- Misc
nmap_leader('q', function() require('mini.bufremove').delete() end, 'Delete current buffer')
nmap_leader('z', function() require('mini.misc').zoom() end, 'Zoom window')

-- Search notes
nmap_leader('nn', '<Cmd>Pick notes<CR>', 'Notes')
nmap_leader('nf', '<Cmd>Pick notes<CR>', 'Notes Find')
nmap_leader('ng', '<Cmd>Pick notes_grep<CR>', 'Notes Grep')

-- 'Harpoon' with :args
nmap_leader('ha', '<Cmd>argadd %<Bar>argdedupe<Bar>args<CR>', 'Add current buffer to the arglist')
nmap_leader('hd', '<Cmd>argdelete %<Bar>argdedupe<Bar>args<CR>', 'Delete current buffer to the arglist')
nmap_leader('hc', '<Cmd>%argdelete<Bar>args<CR><C-L>', 'Clear all buffer args')
nmap_leader('hs', function() vim.notify('Buffer args:\n' .. vim.inspect(vim.fn.argv())) end, 'Show current buffer args')
for i = 1, 9 do
  nmap_leader(i, '<Cmd>' .. i .. 'argument<CR>', 'Goto arg buffer ' .. i)
end
