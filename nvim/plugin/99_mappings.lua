-- Copy to primary selection on select
Keymap({ '<LeftRelease>', '"*ygv', mode = 'v' })

-- Misc
Keymap({ 'x', '"_x', desc = "Avoid 'x' copying to the register" })
Leadermap({ 'y', '"+y', mode = 'x', desc = 'Copy to the system clipboard' })
Leadermap({ 'y', '"+yy', desc = 'Copy to the system clipboard' })

-- Moves lines
Keymap({ 'J', ":m '>+1<CR>gv=gv", mode = 'v' })
Keymap({ 'K', ":m '<-2<CR>gv=gv", mode = 'v' })

-- Navigate wrapped lines (but moves real lines with relative number jumps, eg: 5j)
Keymap({ 'j', "v:count == 0 ? 'gj' : 'j'", expr = true })
Keymap({ 'k', "v:count == 0 ? 'gk' : 'k'", expr = true })

-- Center view on search
Keymap({ 'n', 'nzz' })
Keymap({ 'N', 'Nzz' })

-- Move to window using the <ctrl> hjkl keys
Keymap({ '<C-h>', '<C-w>h', desc = 'Go to left window' })
Keymap({ '<C-j>', '<C-w>j', desc = 'Go to lower window' })
Keymap({ '<C-k>', '<C-w>k', desc = 'Go to upper window' })
Keymap({ '<C-l>', '<C-w>l', desc = 'Go to right window', unique = false })
-- Resize window using <ctrl> arrow keys
Keymap({ '<C-Up>', '<Cmd>resize +2<CR>', desc = 'Increase window height' })
Keymap({ '<C-Down>', '<Cmd>resize -2<CR>', desc = 'Decrease window height' })
Keymap({ '<C-Left>', '<Cmd>vertical resize -2<CR>', desc = 'Decrease window width' })
Keymap({ '<C-Right>', '<Cmd>vertical resize +2<CR>', desc = 'Increase window width' })

-- Clear search with <esc>
Keymap({ '<esc>', '<Cmd>noh<CR><ESC>', mode = { 'i', 'n' }, desc = 'Escape and clear hlsearch' })

-- Don't reset indent on '#', see :h smartindent
Keymap({ '#', 'X#', mode = 'i' })

Leadermap({ 'xl', function() require('quicker').toggle({ loclist = true }) end, desc = 'Location List' })
Leadermap({ 'xq', require('quicker').toggle, desc = 'Quickfix List' })
Leadermap({ 'xd', vim.diagnostic.setqflist, desc = 'Diagnostics to Quickfix' })

-- buffers
Leadermap({ '<TAB>', '<Cmd>bnext<CR>', silent = true, desc = 'Next buffer' })
Leadermap({ 'ba', '<Cmd>b#<CR>', desc = 'Alternate buffer' })
Leadermap({
  'bb',
  function()
    local curbufnr = vim.api.nvim_get_current_buf()
    for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
      if buf.bufnr ~= curbufnr and buf.loaded == 1 and buf.changed == 0 then vim.cmd('bd! ' .. buf.bufnr) end
    end
  end,
  desc = 'Close all other unmodified buffers',
})

-- windows
Leadermap({ 'wc', '<C-W>c', desc = 'Delete window' })
Leadermap({ '-', '<C-W>s', desc = 'Split window below' })
Leadermap({ '|', '<C-W>v', desc = 'Split window right' })

-- others
Keymap({ '<F1>', '<nop>', mode = '' }) -- "" == map
Keymap({ '<F1>', '<nop>', mode = '!' }) -- "!" == map!
vim.api.nvim_create_user_command('W', 'w', { bang = true })
vim.api.nvim_create_user_command('Q', 'q', { bang = true })

-- terminal
Keymap({ '<Esc>', '<C-\\><C-n>', mode = 't', desc = 'Go to normal mode' })

-- quick fix
Leadermap({ 'j', '<Cmd>cnext<CR>', desc = 'Next item in QuickFix' })
Leadermap({ 'k', '<Cmd>cprevious<CR>', desc = 'Previous item in QuickFix' })

-- diagnostics
Leadermap({ 'll', vim.diagnostic.open_float, desc = 'Line diagnostics' })
Leadermap({ 'lq', vim.diagnostic.setloclist, desc = 'Set Loc List' })
Leadermap({ 'lj', function() vim.diagnostic.jump({ count = 1, float = true }) end, desc = 'Next diagnostic' })
Leadermap({ 'lk', function() vim.diagnostic.jump({ count = -1, float = true }) end, desc = 'Prev diagnostic' })

Leadermap({ 'ls', vim.lsp.buf.signature_help, desc = 'Signature' })

Leadermap({
  '<leader>',
  function()
    MiniPick.builtin.buffers({ include_current = false }, {
      mappings = {
        wipeout = {
          char = '<C-d>',
          func = function() vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {}) end,
        },
      },
    })
  end,
  desc = 'Buffers',
})
Leadermap({ 'bm', "<Cmd>Pick marks scope='global'<CR>", desc = 'Global Marks' })
Leadermap({ 'ff', '<Cmd>Pick files<CR>', desc = 'Files' })
Leadermap({ 'fg', '<Cmd>Pick grep_live<CR>', desc = 'Grep live' })
Leadermap({ 'fG', '<Cmd>Pick git_files<CR>', desc = 'Git files' })
Leadermap({ 'fl', '<Cmd>Pick buf_lines scope="current"<CR>', desc = 'Lines (current)' })
Leadermap({ 'fL', '<Cmd>Pick buf_lines scope="all"<CR>', desc = 'Lines (all)' })
Leadermap({ 'fd', '<Cmd>Pick diagnostic scope="current"<CR>', desc = 'Diagnostic buffer' })
Leadermap({ 'fD', '<Cmd>Pick diagnostic scope="all"<CR>', desc = 'Diagnostic workspace' })
Leadermap({ 'fa', '<Cmd>Pick git_hunks scope="staged"<CR>', desc = 'Added hunks (all)' })
Leadermap({ 'fA', '<Cmd>Pick git_hunks path="%" scope="staged"<CR>', desc = 'Added hunks (buf)' })
Leadermap({ 'fm', '<Cmd>Pick git_hunks path="%:p" n_context=0<CR>', desc = 'Modified hunks (current)' })
Leadermap({ 'fM', '<Cmd>Pick git_hunks<CR>', desc = 'Modified hunks (all)' })
Leadermap({ 'fr', '<Cmd>Pick resume<CR>', desc = 'Resume' })
Leadermap({ 'fR', '<Cmd>Pick lsp scope="references"<CR>', desc = 'References (LSP)' })
Leadermap({ 'fs', '<Cmd>Pick lsp scope="document_symbol"<CR>', desc = 'Symbols buffer (LSP)' })
Leadermap({ 'fS', '<Cmd>Pick lsp scope="workspace_symbol"<CR>', desc = 'Symbols workspace (LSP)' })
Leadermap({ 'fh', '<Cmd>Pick help<CR>', desc = 'Help tags' })
Leadermap({ 'fH', '<Cmd>Pick hl_groups<CR>', desc = 'Highlight groups' })
Leadermap({ 'fp', '<Cmd>Pick spellsuggest<CR>', desc = 'Spell suggest' })
Leadermap({ 'fk', '<Cmd>Pick keymaps<CR>', desc = 'Keymaps' })

local git_log_cmd = [[Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order]]
local git_reflog_cmd = [[Git log --abbrev-commit --walk-reflogs --pretty=format:\%h\ \%ai\ \%al\ |\ \%s\ |\ \%d]] -- similar to 'git reflog'
local git_graph_cmd = [[Git log --graph --all --pretty=format:\%h\ \%ai\ \%al\ |\ \%s\ |\ \%d]]
Leadermap({ 'gp', '<Cmd>Git log -p -- %:p<CR>', desc = 'Git log -p <file>' })
Leadermap({ 'ga', '<Cmd>Git diff --cached -- %:p<CR>', desc = 'Added diff buffer' })
Leadermap({ 'gA', '<Cmd>Git diff --cached<CR>', desc = 'Added diff' })
Leadermap({ 'gd', '<Cmd>Git diff -- %:p<CR>', desc = 'Diff buffer' })
Leadermap({ 'gD', '<Cmd>Git diff<CR>', desc = 'Diff' })
Leadermap({ 'gb', '<Cmd>Git blame -- %:p<CR>', desc = 'Blame buffer' })
Leadermap({ 'gl', '<Cmd>' .. git_log_cmd .. ' --follow -- %:p<CR>', desc = 'Log buffer' })
Leadermap({ 'gL', '<Cmd>' .. git_log_cmd .. '<CR>', desc = 'Log' })
Leadermap({ 'gr', '<Cmd>tab ' .. git_reflog_cmd .. '<CR>', desc = 'Reflog' })
Leadermap({ 'gg', '<Cmd>tab ' .. git_graph_cmd .. '<CR>', desc = 'Graph' })
Leadermap({ 'go', '<Cmd>lua MiniDiff.toggle_overlay()<CR>', desc = 'Toggle diff overlay' })
Leadermap({ 'gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>', desc = 'Show at cursor' })
Leadermap({ 'gc', '<Cmd>Pick git_commits path="%:p"<CR>', desc = '[Pick] Commits (current)' })
Leadermap({ 'gC', '<Cmd>Pick git_commits<CR>', desc = '[Pick] Commits (all)' })

-- Show at cursor already gives info from show_range_history
Leadermap({ 'gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>', mode = 'x', desc = 'Show at selection' })
Leadermap({
  'gb',
  function() vim.cmd('Git log -L ' .. vim.fn.line("'<") .. ',' .. vim.fn.line("'>") .. ':' .. vim.fn.expand('%:p')) end,
  mode = 'x',
  desc = 'Blame selection',
})

-- LSP
Keymap({ 'grd', vim.lsp.buf.definition, desc = 'Definitions' }) -- 'gd' is 'definition in function'
Keymap({ 'grD', vim.lsp.buf.declaration, desc = 'Declaration' }) -- 'gD' is 'definition in file'
--- 'gi' by default is mapped to 'Start Insert where it stopped', so better not remap that
--- 'gra'/'gri'/'grn'/'grr'/'grt'/'gO' are default as of nvim 0.11, see :h lsp-defaults

-- Formatting
Leadermap({ 'lf', function() require('conform').format() end, mode = { 'n', 'x' }, desc = 'Format buffer' })

-- Outline
Leadermap({ 'lo', '<Cmd>Outline<CR>', desc = 'Toggle Outline' })

-- Oil (add --preview to open with preview enabled directly, but it is distracting, rather toggle it with C-p)
Keymap({ '-', '<Cmd>Oil<CR>', desc = 'Open parent directory' })

-- Undotree
Leadermap({
  'u',
  function()
    vim.cmd('packadd nvim.undotree')
    require('undotree').open({ command = 'leftabove 32vnew' })
  end,
  desc = 'Undotree',
})

-- Toggles
Leadermap({ 'tc', '<Cmd>setlocal cursorline! cursorline?<CR>', desc = 'Toggle cursorline' })
Leadermap({ 'tC', '<Cmd>setlocal cursorcolumn! cursorcolumn?<CR>', desc = 'Toggle cursorcolumn' })
Leadermap({
  'td',
  function()
    local is_enabled = vim.diagnostic.is_enabled({ bufnr = 0 })
    vim.diagnostic.enable(not is_enabled, { bufnr = 0 })
    print(is_enabled and 'nodiagnostic' or '  diagnostic')
  end,
  desc = 'Toggle diagnostic',
})
Leadermap({ 'tl', '<Cmd>setlocal list! list?<CR>', desc = 'Toggle list' })
Leadermap({ 'tn', '<Cmd>setlocal number! number?<CR>', desc = 'Toggle number' })
Leadermap({ 'tr', '<Cmd>setlocal relativenumber! relativenumber?<CR>', desc = 'Toggle relativenumber' })
Leadermap({ 'ts', '<Cmd>setlocal spell! spell?<CR>', desc = 'Toggle spell' })
Leadermap({ 'tw', '<Cmd>setlocal wrap! wrap?<CR>', desc = 'Toggle wrap' })
Leadermap({
  'tx',
  function()
    local ctx = require('treesitter-context')
    ctx.toggle()
    print(ctx.enabled() and '  tscontext' or 'notscontext')
  end,
  desc = 'Toggle context',
})

-- Misc
Leadermap({ 'q', function() require('mini.bufremove').delete() end, desc = 'Delete current buffer' })
Leadermap({ 'z', function() require('mini.misc').zoom() end, desc = 'Zoom window' })

-- 'Harpoon' with :args
Leadermap({ 'ha', '<Cmd>argadd %<Bar>argdedupe<Bar>args<CR>', desc = 'Add current buffer to the arglist' })
Leadermap({ 'hd', '<Cmd>argdelete %<Bar>argdedupe<Bar>args<CR>', desc = 'Delete current buffer to the arglist' })
Leadermap({ 'hc', '<Cmd>%argdelete<Bar>args<CR><C-L>', desc = 'Clear all buffer args' })
for i = 1, 9 do
  Leadermap({ tostring(i), '<Cmd>' .. i .. 'argument<CR>', desc = 'Goto arg buffer ' .. i })
end
Leadermap({ 'hf', '<Cmd>Pick harpoon<CR>', desc = 'Pick' })

-- Run cmd in terminal (overridden in some filetypes)
Leadermap({ 'e', '<Cmd>Term<CR>', desc = 'Run cmd in a terminal' })

-- Notes
Leadermap({
  'nn',
  function()
    vim.fn.chdir(Config.notes_dir)
    require('oil').open(nil, { preview = {} })
  end,
  desc = 'Notes',
})
Leadermap({ 'nf', '<Cmd>Pick notes<CR>', desc = 'Notes Find' })
Leadermap({ 'ng', '<Cmd>Pick notes_grep<CR>', desc = 'Notes Grep' })
