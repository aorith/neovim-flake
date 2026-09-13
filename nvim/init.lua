-------------------------------------------------------------------------------
-- GLOBALS
-------------------------------------------------------------------------------
require('vim._core.ui2').enable()
require('config.utils')

_G.Config = {
  nvim_appname = vim.env.NVIM_APPNAME or 'nvim',
  notes_dir = vim.env.HOME .. '/Syncthing/SYNC_STUFF/notes/md',

  on_nix = (vim.env.NVIM_NIX == '1' or vim.uv.fs_stat('/etc/nixos')) and true or false,

  -- Files bigger than this are detected as the 'bigfile' filetype (see 'filetype.lua')
  bigfile_size = 1.5 * 1024 * 1024,

  -- Should be populated after gopls init
  gopls = { goimports_args = nil },
}

-- Leader keys must be set before any mapping is defined
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\' -- Using ',' breaks: f<letter> + ;,
