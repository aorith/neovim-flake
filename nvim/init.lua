vim.loader.enable()

--- Global configuration and functions
-------------------------------------------------------------------------------
_G.Config = {
  notes_dir = vim.env.HOME .. '/Syncthing/SYNC_STUFF/notes/zk/notes',

  ---@diagnostic disable-next-line: undefined-field
  on_nix = (vim.env.NVIM_NIX == '1' or vim.uv.fs_stat('/etc/nixos')) and true or false,

  --- Function to modify an existing highlight group in Neovim
  ---@param name string The name of the highlight group to modify
  ---@param opts table A table containing highlight options (e.g., colors, styles)
  hi = function(name, opts)
    local is_ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name })
    if is_ok then
      vim.iter(opts):each(function(k, v) hl[k] = v end)
      pcall(vim.api.nvim_set_hl, 0, name, hl)
    end
  end,

  -- Show debug mode in statusline when nvim-dap is enabled
  debug_mode = false,
}

-- Define custom autocommand group and helper to create an autocommand.
local gr = vim.api.nvim_create_augroup('ao-custom-config', {})
_G.Config.new_autocmd = function(event, pattern, callback, desc)
  local opts = { group = gr, pattern = pattern, callback = callback, desc = desc }
  vim.api.nvim_create_autocmd(event, opts)
end

--- Bootstrap 'mini.deps'
-------------------------------------------------------------------------------
local mini_path = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim'
---@diagnostic disable-next-line: undefined-field
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local origin = 'https://github.com/nvim-mini/mini.nvim'
  local clone_cmd = { 'git', 'clone', '--filter=blob:none', origin, mini_path }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup({ job = { n_threads = 4 } })
