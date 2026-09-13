require('mini.pick').setup({
  window = { config = function() return { width = vim.o.columns } end },

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

-------------------------------------------------------------------------------
-- 'Harpoon' with :args
-------------------------------------------------------------------------------
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

Leadermap({ 'ha', '<Cmd>argadd %<Bar>argdedupe<Bar>args<CR>', desc = 'Add current buffer to the arglist' })
Leadermap({ 'hd', '<Cmd>argdelete %<Bar>argdedupe<Bar>args<CR>', desc = 'Delete current buffer to the arglist' })
Leadermap({ 'hc', '<Cmd>%argdelete<Bar>args<CR><C-L>', desc = 'Clear all buffer args' })
Leadermap({ 'hf', '<Cmd>Pick harpoon<CR>', desc = 'Pick' })
for i = 1, 9 do
  Leadermap({ tostring(i), '<Cmd>' .. i .. 'argument<CR>', desc = 'Goto arg buffer ' .. i })
end

-------------------------------------------------------------------------------
-- Notes ('<Leader>nn' uses oil, see 'plugin/34_oil.lua')
-------------------------------------------------------------------------------
MiniPick.registry.notes = function()
  vim.fn.chdir(Config.notes_dir)
  local command = { 'fd', '--type', 'f', '--glob', '*.md' }
  return MiniPick.builtin.cli({ command = command }, {
    source = { name = 'Notes', cwd = Config.notes_dir },
  })
end

MiniPick.registry.notes_grep = function()
  vim.fn.chdir(Config.notes_dir)
  local opts = { source = { cwd = Config.notes_dir } }
  return MiniPick.builtin.grep_live({ globs = { '*.md' } }, opts)
end

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
