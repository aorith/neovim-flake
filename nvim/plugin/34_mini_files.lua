---@diagnostic disable-next-line: redundant-parameter
require('mini.files').setup({
  -- Module mappings created only inside explorer.
  -- Use `''` (empty string) to not create one.
  mappings = {
    close = 'q',
    go_in = '',
    go_in_plus = '<CR>',
    go_out = '-',
    go_out_plus = '',
    reset = '<BS>',
    reveal_cwd = '@',
    show_help = 'g?',
    synchronize = '=',
    trim_left = '<',
    trim_right = '>',
  },

  options = {
    permanent_delete = false,
    use_as_default_explorer = true,
  },

  windows = {
    -- Cap at 3 columns: parent, current and preview
    max_number = 3,
    preview = true,
  },
})

Keys.map('n', '-', function() MiniFiles.open(vim.api.nvim_buf_get_name(0), false) end, 'Open parent directory')

-- Toggle hidden files
local show_dotfiles = false
local filter_show = function(_) return true end
local filter_hide = function(fs_entry) return not vim.startswith(fs_entry.name, '.') end
local toggle_dotfiles = function()
  show_dotfiles = not show_dotfiles
  local new_filter = show_dotfiles and filter_show or filter_hide
  MiniFiles.refresh({ content = { filter = new_filter } })
end

-- Open files in a split
local map_split = function(buf_id, lhs, direction)
  local rhs = function()
    local cur_target = MiniFiles.get_explorer_state().target_window
    local new_target = vim.api.nvim_win_call(cur_target, function()
      vim.cmd(direction .. ' split')
      return vim.api.nvim_get_current_win()
    end)

    MiniFiles.set_target_window(new_target)
  end

  Keys.map_buffer('n', lhs, rhs, 'Split ' .. direction, { buf = buf_id })
end

-- Set focused directory as current working directory
local set_cwd = function()
  local path = (MiniFiles.get_fs_entry() or {}).path
  if path == nil then return vim.notify('Cursor is not on valid entry') end
  vim.fn.chdir(vim.fs.dirname(path))
end

-- Open path with system default handler (useful for non-text files)
local ui_open = function() vim.ui.open(MiniFiles.get_fs_entry().path) end

NewAutocmd('mini-files-mappings', nil, 'User', 'MiniFilesBufferCreate', function(args)
  local buf_id = args.data.buf_id
  Keys.map_buffer('n', 'g.', toggle_dotfiles, 'Toggle hidden files', { buf = buf_id })
  Keys.map_buffer('n', 'gw', set_cwd, 'Set cwd', { buf = buf_id })
  Keys.map_buffer('n', 'gX', ui_open, 'OS open', { buf = buf_id })
  Keys.map_buffer('n', '<Esc>', MiniFiles.close, 'Close', { buf = buf_id })
  map_split(buf_id, '<C-s>', 'belowright horizontal')
  map_split(buf_id, '<C-v>', 'belowright vertical')
  map_split(buf_id, '<C-t>', 'tab')
end, 'Setup minifiles mappings')
