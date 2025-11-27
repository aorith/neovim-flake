---@diagnostic disable-next-line: redundant-parameter
require('mini.pick').setup({
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

MiniPick.registry.notes = function(local_opts)
  vim.fn.chdir(Config.notes_dir)
  local opts = { source = { cwd = Config.notes_dir } }
  return MiniPick.builtin.files(local_opts, opts)
end

MiniPick.registry.notes_grep = function(local_opts)
  vim.fn.chdir(Config.notes_dir)
  local opts = { source = { cwd = Config.notes_dir } }
  return MiniPick.builtin.grep_live(local_opts, opts)
end

-- Pick files from arglist
MiniPick.registry.harpoon = function()
  local items = vim.fn.argv() --[[@as string[] ]]

  -- Create items with metadata
  local picker_items = {}
  for i, arg in ipairs(items) do
    table.insert(picker_items, {
      text = string.format('%d: %s', i, arg),
      path = arg,
      arg_index = i,
    })
  end

  -- Custom choose function to open via :argument command
  local choose = function(item)
    local win_id = MiniPick.get_picker_state().windows.target
    vim.api.nvim_win_call(win_id, function() vim.cmd(item.arg_index .. 'argument') end)
  end

  local source = {
    items = picker_items,
    name = 'Harpoon',
    choose = choose,
  }

  return MiniPick.start({ source = source })
end
