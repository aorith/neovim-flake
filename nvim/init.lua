-- Global configuration and functions.
_G.Config = {
  nvim_appname = vim.env.NVIM_APPNAME ~= nil and vim.env.NVIM_APPNAME or 'nvim',

  on_nix = (vim.env.NVIM_NIX == '1' or vim.uv.fs_stat('/etc/nixos')) and true or false,

  -- Should be populated after gopls init
  gopls = { goimports_args = nil },
}

-- Define custom autocommand group and helper to create an autocommand.
local gr = vim.api.nvim_create_augroup('ao-custom-config', {})
Config.new_autocmd = function(event, pattern, callback, desc)
  local opts = { group = gr, pattern = pattern, callback = callback, desc = desc }
  vim.api.nvim_create_autocmd(event, opts)
end
