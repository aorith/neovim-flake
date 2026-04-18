vim.pack.add({
  { src = 'https://github.com/nvim-mini/mini-git' },
  { src = 'https://github.com/nvim-mini/mini.ai' },
  { src = 'https://github.com/nvim-mini/mini.bufremove' },
  { src = 'https://github.com/nvim-mini/mini.clue' },
  { src = 'https://github.com/nvim-mini/mini.completion' },
  { src = 'https://github.com/nvim-mini/mini.diff' },
  { src = 'https://github.com/nvim-mini/mini.extra' },
  { src = 'https://github.com/nvim-mini/mini.hipatterns' },
  { src = 'https://github.com/nvim-mini/mini.hues' },
  { src = 'https://github.com/nvim-mini/mini.icons' },
  { src = 'https://github.com/nvim-mini/mini.indentscope' },
  { src = 'https://github.com/nvim-mini/mini.jump' },
  { src = 'https://github.com/nvim-mini/mini.jump2d' },
  { src = 'https://github.com/nvim-mini/mini.keymap' },
  { src = 'https://github.com/nvim-mini/mini.misc' },
  { src = 'https://github.com/nvim-mini/mini.notify' },
  { src = 'https://github.com/nvim-mini/mini.pick' },
  { src = 'https://github.com/nvim-mini/mini.snippets' },
  { src = 'https://github.com/nvim-mini/mini.surround' },
  { src = 'https://github.com/nvim-mini/mini.tabline' },
  { src = 'https://github.com/nvim-mini/mini.trailspace' },

  { src = 'https://github.com/sainnhe/gruvbox-material' },

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
vim.g.gruvbox_material_foreground = 'mix'
vim.g.gruvbox_material_statusline_style = 'mix'
vim.g.gruvbox_material_sign_column_background = 'linenr'
vim.g.gruvbox_material_diagnostic_text_highlight = 1
vim.g.gruvbox_material_diagnostic_line_highlight = 1
vim.g.gruvbox_material_diagnostic_virtual_text = 'highlighted'

if vim.o.background == 'dark' then
  vim.cmd.colorscheme('gruvbox-material')
else
  vim.cmd.colorscheme('miniwinter')
end
