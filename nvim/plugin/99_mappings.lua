-- Copy to primary selection on select
Keys.map('v', '<LeftRelease>', '"*ygv')

-- Misc
Keys.map('n', 'x', '"_x') -- Avoid 'x' copying to the register
Keys.map_leader('x', 'y', '"+y', 'Copy to the system clipboard')
Keys.map_leader('n', 'y', '"+yy', 'Copy to the system clipboard')

-- Moves lines
Keys.map('v', 'K', ":m '<-2<CR>gv=gv")
Keys.map('v', 'J', ":m '>+1<CR>gv=gv")

-- Navigate wrapped lines (but moves real lines with relative number jumps, eg: 5j)
Keys.map('n', 'k', "v:count == 0 ? 'gk' : 'k'", nil, { expr = true })
Keys.map('n', 'j', "v:count == 0 ? 'gj' : 'j'", nil, { expr = true })

-- Center view on search
Keys.map('n', 'n', 'nzz')
Keys.map('n', 'N', 'Nzz')

-- Move to window using the <ctrl> hjkl keys
Keys.map('n', '<C-h>', '<C-w>h', 'Go to left window')
Keys.map('n', '<C-j>', '<C-w>j', 'Go to lower window')
Keys.map('n', '<C-k>', '<C-w>k', 'Go to upper window')
Keys.map('n', '<C-l>', '<C-w>l', 'Go to right window', { unique = false })
-- Resize window using <ctrl> arrow keys
Keys.map('n', '<C-Up>', '<Cmd>resize +2<CR>', 'Increase window height')
Keys.map('n', '<C-Down>', '<Cmd>resize -2<CR>', 'Decrease window height')
Keys.map('n', '<C-Left>', '<Cmd>vertical resize -2<CR>', 'Decrease window width')
Keys.map('n', '<C-Right>', '<Cmd>vertical resize +2<CR>', 'Increase window width')

-- Clear search with <esc>
Keys.map({ 'i', 'n' }, '<esc>', '<Cmd>noh<CR><ESC>')

-- Don't reset indent on '#', see :h smartindent
Keys.map('i', '#', 'X#')

-- buffers
Keys.map_leader('n', '<TAB>', '<Cmd>bnext<CR>', 'Next buffer')
Keys.map_leader('n', 'ba', '<Cmd>b#<CR>', 'Alternate buffer')
Keys.map_leader('n', 'bb', function()
  local curbufnr = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
    if buf.bufnr ~= curbufnr and buf.loaded == 1 and buf.changed == 0 then vim.cmd('bd! ' .. buf.bufnr) end
  end
end, 'Close all other unmodified buffers')

-- windows
Keys.map_leader('n', 'wc', '<C-W>c', 'Delete window')
Keys.map_leader('n', '-', '<C-W>s', 'Split window below')
Keys.map_leader('n', '|', '<C-W>v', 'Split window right')

-- others
Keys.map('', '<F1>', '<nop>') -- "" == map
Keys.map('!', '<F1>', '<nop>') -- "!" == map!
vim.api.nvim_create_user_command('W', 'w', { bang = true })
vim.api.nvim_create_user_command('Q', 'q', { bang = true })

-- terminal
Keys.map('t', '<Esc>', '<C-\\><C-n>', 'Go to normal mode')

-- quick fix
Keys.map_leader('n', 'j', '<Cmd>cnext<CR>', 'Next item in QuickFix')
Keys.map_leader('n', 'k', '<Cmd>cprevious<CR>', 'Previous item in QuickFix')

-- Undotree, bundled with Neovim in '$VIMRUNTIME/pack/dist/opt/nvim.undotree'
Keys.map_leader('n', 'u', function()
  vim.cmd('packadd nvim.undotree')
  require('undotree').open({ command = 'leftabove 32vnew' })
end, 'Undotree')

-- Toggles ('<Leader>td' is with the diagnostics, '<Leader>tx' with treesitter)
Keys.map_leader('n', 'tc', '<Cmd>setlocal cursorline! cursorline?<CR>', 'Toggle cursorline')
Keys.map_leader('n', 'tC', '<Cmd>setlocal cursorcolumn! cursorcolumn?<CR>', 'Toggle cursorcolumn')
Keys.map_leader('n', 'tl', '<Cmd>setlocal list! list?<CR>', 'Toggle list')
Keys.map_leader('n', 'tn', '<Cmd>setlocal number! number?<CR>', 'Toggle number')
Keys.map_leader('n', 'tr', '<Cmd>setlocal relativenumber! relativenumber?<CR>', 'Toggle relativenumber')
Keys.map_leader('n', 'ts', '<Cmd>setlocal spell! spell?<CR>', 'Toggle spell')
Keys.map_leader('n', 'tw', '<Cmd>setlocal wrap! wrap?<CR>', 'Toggle wrap')

-- Run cmd in terminal (overridden in some filetypes)
Keys.map_leader('n', 'e', '<Cmd>Term<CR>', 'Run cmd in a terminal')
