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

Keys.map_leader('n', '<leader>', function()
  MiniPick.builtin.buffers({ include_current = false }, {
    mappings = {
      wipeout = {
        char = '<C-d>',
        func = function() vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {}) end,
      },
    },
  })
end, 'Pick Buffers')
Keys.map_leader('n', 'bm', "<Cmd>Pick marks scope='global'<CR>", 'Global Marks')
Keys.map_leader('n', 'ff', '<Cmd>Pick files<CR>', 'Files')
Keys.map_leader('n', 'fg', '<Cmd>Pick grep_live<CR>', 'Grep live')
Keys.map_leader('n', 'fG', '<Cmd>Pick git_files<CR>', 'Git files')
Keys.map_leader('n', 'fl', '<Cmd>Pick buf_lines scope="current"<CR>', 'Lines (current)')
Keys.map_leader('n', 'fL', '<Cmd>Pick buf_lines scope="all"<CR>', 'Lines (all)')
Keys.map_leader('n', 'fd', '<Cmd>Pick diagnostic scope="current"<CR>', 'Diagnostic buffer')
Keys.map_leader('n', 'fD', '<Cmd>Pick diagnostic scope="all"<CR>', 'Diagnostic workspace')
Keys.map_leader('n', 'fa', '<Cmd>Pick git_hunks scope="staged"<CR>', 'Added hunks (all)')
Keys.map_leader('n', 'fA', '<Cmd>Pick git_hunks path="%" scope="staged"<CR>', 'Added hunks (buf)')
Keys.map_leader('n', 'fm', '<Cmd>Pick git_hunks path="%:p" n_context=0<CR>', 'Modified hunks (current)')
Keys.map_leader('n', 'fM', '<Cmd>Pick git_hunks<CR>', 'Modified hunks (all)')
Keys.map_leader('n', 'gc', '<Cmd>Pick git_commits path="%:p"<CR>', '[Pick] Commits (current)')
Keys.map_leader('n', 'gC', '<Cmd>Pick git_commits<CR>', '[Pick] Commits (all)')
Keys.map_leader('n', 'fr', '<Cmd>Pick resume<CR>', 'Resume')
Keys.map_leader('n', 'fR', '<Cmd>Pick lsp scope="references"<CR>', 'References (LSP)')
Keys.map_leader('n', 'fs', '<Cmd>Pick lsp scope="document_symbol"<CR>', 'Symbols buffer (LSP)')
Keys.map_leader('n', 'fS', '<Cmd>Pick lsp scope="workspace_symbol"<CR>', 'Symbols workspace (LSP)')
Keys.map_leader('n', 'fh', '<Cmd>Pick help<CR>', 'Help tags')
Keys.map_leader('n', 'fH', '<Cmd>Pick hl_groups<CR>', 'Highlight groups')
Keys.map_leader('n', 'fp', '<Cmd>Pick spellsuggest<CR>', 'Spell suggest')
Keys.map_leader('n', 'fk', '<Cmd>Pick keymaps<CR>', 'Keymaps')

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

Keys.map_leader('n', 'ha', '<Cmd>argadd %<Bar>argdedupe<Bar>args<CR>', 'Add current buffer to the arglist')
Keys.map_leader('n', 'hd', '<Cmd>argdelete %<Bar>argdedupe<Bar>args<CR>', 'Delete current buffer to the arglist')
Keys.map_leader('n', 'hc', '<Cmd>%argdelete<Bar>args<CR><C-L>', 'Clear all buffer args')
Keys.map_leader('n', 'hf', '<Cmd>Pick harpoon<CR>', 'Pick')
for i = 1, 9 do
  Keys.map_leader('n', tostring(i), '<Cmd>' .. i .. 'argument<CR>', 'Goto arg buffer ' .. i)
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

Keys.map_leader('n', 'nn', function()
  vim.fn.chdir(Config.notes_dir)
  require('oil').open(nil, { preview = {} })
end, 'Notes')
Keys.map_leader('n', 'nf', '<Cmd>Pick notes<CR>', 'Notes Find')
Keys.map_leader('n', 'ng', '<Cmd>Pick notes_grep<CR>', 'Notes Grep')
