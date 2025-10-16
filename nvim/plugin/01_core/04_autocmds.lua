-- Highlight on yank
Config.new_autocmd('TextYankPost', '*', function() vim.hl.on_yank() end, 'Highlight on yank')

-- Go to the last line edited when opening a file
Config.new_autocmd('BufReadPost', '*', function(data)
  -- skip some filetypes
  if
    vim.tbl_contains({ 'minifiles', 'minipick', 'snacks_picker_input', 'gitcommit' }, vim.bo.filetype)
    or vim.bo.buftype == 'prompt'
  then
    return
  end
  local last_pos = vim.api.nvim_buf_get_mark(data.buf, '"')
  if last_pos[1] > 0 and last_pos[1] <= vim.api.nvim_buf_line_count(data.buf) then
    vim.api.nvim_win_set_cursor(0, last_pos)
  end
end, 'Go to the last known line of the file')

-- close some filetypes with <q>
Config.new_autocmd('FileType', {
  'help',
  'lspinfo',
  'man',
  'notify',
  'qf',
  'spectre_panel',
}, function(event)
  vim.bo[event.buf].buflisted = false
  vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
end, "Close file with 'q'")

-- Don't auto-wrap comments and don't insert comment leader after hitting 'o'.
-- Do on `FileType` to always override these changes from filetype plugins.
local f = function() vim.cmd('setlocal formatoptions-=c formatoptions-=o') end
Config.new_autocmd('FileType', nil, f, "Proper 'formatoptions'")

-- Theme overrides
Config.new_autocmd('ColorScheme', '*', function()
  -- Ensure that mini.cursorword always highlights without using underline
  -- vim.api.nvim_set_hl(0, "MiniCursorWord", { link = "Visual" })
  -- vim.api.nvim_set_hl(0, "MiniCursorWordCurrent", { link = "Visual" })

  -- Make MiniJump more noticeable
  vim.api.nvim_set_hl(0, 'MiniJump', { link = 'Search' })

  Config.hi('Comment', { italic = true })
  Config.hi('@comment.error', { italic = true })
  Config.hi('@comment.warning', { italic = true })
  Config.hi('@comment.todo', { italic = true })
  Config.hi('@comment.note', { italic = true })

  -- treesitter.context
  vim.api.nvim_set_hl(0, 'TreesitterContextLineNumber', { link = 'TreesitterContext' })
end, 'Theme overrides')
