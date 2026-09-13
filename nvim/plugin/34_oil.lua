require('oil').setup({
  delete_to_trash = true,
  watch_for_changes = true,
  keymaps = {
    ['q'] = { 'actions.close', mode = 'n' },
    ['<C-h>'] = false,
    ['<C-l>'] = false,
    ['<C-s>'] = { 'actions.select', opts = { horizontal = true } },
    ['<C-Return>'] = { 'actions.select', opts = { vertical = true } },
  },
})

-- Add --preview to open with preview enabled directly, but it is distracting,
-- rather toggle it with C-p. '<Leader>nn' opens the notes dir, see 'plugin/22_mini_pick.lua'
Keymap({ '-', '<Cmd>Oil<CR>', desc = 'Open parent directory' })
