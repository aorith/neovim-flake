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

-- Undotree, bundled with Neovim in '$VIMRUNTIME/pack/dist/opt/nvim.undotree'
Leadermap({
  'u',
  function()
    vim.cmd('packadd nvim.undotree')
    require('undotree').open({ command = 'leftabove 32vnew' })
  end,
  desc = 'Undotree',
})

-- Toggles ('<Leader>td' is with the diagnostics, '<Leader>tx' with treesitter)
Leadermap({ 'tc', '<Cmd>setlocal cursorline! cursorline?<CR>', desc = 'Toggle cursorline' })
Leadermap({ 'tC', '<Cmd>setlocal cursorcolumn! cursorcolumn?<CR>', desc = 'Toggle cursorcolumn' })
Leadermap({ 'tl', '<Cmd>setlocal list! list?<CR>', desc = 'Toggle list' })
Leadermap({ 'tn', '<Cmd>setlocal number! number?<CR>', desc = 'Toggle number' })
Leadermap({ 'tr', '<Cmd>setlocal relativenumber! relativenumber?<CR>', desc = 'Toggle relativenumber' })
Leadermap({ 'ts', '<Cmd>setlocal spell! spell?<CR>', desc = 'Toggle spell' })
Leadermap({ 'tw', '<Cmd>setlocal wrap! wrap?<CR>', desc = 'Toggle wrap' })

-- Run cmd in terminal (overridden in some filetypes)
Leadermap({ 'e', '<Cmd>Term<CR>', desc = 'Run cmd in a terminal' })
