vim.pack.add({
  { src = 'https://github.com/nvim-mini/mini.nvim', version = 'main' },

  { src = 'https://github.com/tpope/vim-sleuth' }, -- auto-detect shiftwidth, expandtab, etc.
  { src = 'https://github.com/varnishcache-friends/vim-varnish' },

  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/stevearc/conform.nvim' },
  { src = 'https://github.com/mfussenegger/nvim-lint' },
  { src = 'https://github.com/hedyhli/outline.nvim' },
  { src = 'https://github.com/stevearc/quicker.nvim' },
  { src = 'https://github.com/stevearc/oil.nvim' },
})

if not Config.on_nix then
  vim.pack.add({
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },
  })
end

-- Colorscheme
vim.cmd.colorscheme('default')
