vim.pack.add({
  { src = 'https://github.com/nvim-mini/mini.nvim', version = 'main' },

  { src = 'https://github.com/varnishcache-friends/vim-varnish' },

  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/stevearc/conform.nvim' },
  { src = 'https://github.com/mfussenegger/nvim-lint' },
  { src = 'https://github.com/hedyhli/outline.nvim' },
  { src = 'https://github.com/stevearc/quicker.nvim' },
  { src = 'https://github.com/stevearc/oil.nvim' },

  { src = 'https://github.com/sainnhe/gruvbox-material' },
})

if not Config.on_nix then
  vim.pack.add({
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },
  })
end

-- Colorscheme

-- Colorscheme
vim.g.gruvbox_material_background = 'hard'
vim.g.gruvbox_material_foreground = 'original'
vim.g.gruvbox_material_statusline_style = 'mix'
vim.g.gruvbox_material_sign_column_background = 'linenr'
vim.g.gruvbox_material_diagnostic_text_highlight = 1
vim.g.gruvbox_material_diagnostic_line_highlight = 1
vim.g.gruvbox_material_diagnostic_virtual_text = 'highlighted'

vim.cmd.colorscheme('gruvbox-material')
