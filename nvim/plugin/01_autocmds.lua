-- Bigfile detection registers its filetype pattern in 'filetype.lua'
local function on_bigfile(ev)
  vim.b.minianimate_disable = true
  vim.schedule(function()
    vim.bo[ev.buf].syntax = ev.ft

    local winid = vim.api.nvim_get_current_win()
    vim.wo[winid][0].cursorlineopt = 'number'
  end)
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(ev.buf), ':p:~:.')
  vim.notify(('Big file detected `%s`.'):format(path))
end

NewAutocmd('bigfile', nil, 'FileType', 'bigfile', function(ev)
  vim.api.nvim_buf_call(
    ev.buf,
    function()
      on_bigfile({
        buf = ev.buf,
        ft = vim.filetype.match({ buf = ev.buf }) or '',
      })
    end
  )
end, 'Bigfile')

-- Autoread on focus/terminal events (required by tmux); skip scratch buffers
NewAutocmd('autoread-focus', nil, { 'FocusGained', 'TermClose', 'TermLeave' }, nil, function()
  if vim.bo.buftype ~= 'nofile' then vim.cmd('checktime') end
end, 'Autoread on focus/terminal events')

-- Highlight on yank
NewAutocmd('hl-yank', nil, 'TextYankPost', nil, function() vim.hl.on_yank() end, 'Highlight on yank')

-- Re-equalize splits when the terminal is resized
NewAutocmd('resize-splits', nil, 'VimResized', nil, function()
  local current_tab = vim.fn.tabpagenr()
  vim.cmd('tabdo wincmd =')
  vim.cmd('tabnext ' .. current_tab)
end, 'Equalize splits on resize')

-- close some filetypes with <q>
NewAutocmd('close-on-q', nil, 'FileType', {
  'git',
  'diff',
  'help',
  'lspinfo',
  'man',
  'notify',
  'qf',
  'spectre_panel',
  'nvim-undotree',
}, function(event)
  vim.bo[event.buf].buflisted = false
  Bufmap({ 'q', '<cmd>close<cr>', silent = true })
end, "Close file with 'q'")

-- Don't auto-wrap comments and don't insert comment leader after hitting 'o'.
-- Do on `FileType` to always override these changes from filetype plugins.
NewAutocmd(
  'no-auto-wrap',
  nil,
  'FileType',
  nil,
  function() vim.cmd('setlocal formatoptions-=c formatoptions-=o') end,
  "Proper 'formatoptions'"
)

-- Theme overrides
NewAutocmd('theme-overrides', nil, 'ColorScheme', nil, function()
  -- treesitter.context
  vim.api.nvim_set_hl(0, 'TreesitterContextLineNumber', { link = 'TreesitterContext' })
end, 'Theme overrides')
