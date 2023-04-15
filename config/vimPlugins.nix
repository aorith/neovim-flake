{pkgs}:
with pkgs.vimPlugins; [
  # theme
  catppuccin-nvim
  #kanagawa-nvim
  #nord-nvim
  #onedark-nvim
  #tokyonight-nvim

  lualine-nvim
  neo-tree-nvim
  which-key-nvim
  #indent-blankline-nvim
  gitsigns-nvim
  undotree
  toggleterm-nvim

  telescope-nvim
  telescope-fzf-native-nvim
  telescope-manix # nix documentation

  nvim-treesitter-textobjects
  nvim-treesitter.withAllGrammars

  # Completion
  nvim-cmp
  cmp-buffer
  cmp-cmdline
  cmp-nvim-lsp
  cmp-nvim-lsp-signature-help
  cmp-path
  cmp_luasnip
  luasnip

  # LSP
  nvim-lspconfig
  null-ls-nvim
  trouble-nvim
  nvim-navic

  # UI
  #noice-nvim
  #nvim-notify

  # deps
  dressing-nvim
  lspkind-nvim
  nui-nvim
  nvim-web-devicons
  plenary-nvim
  refactoring-nvim

  vim-commentary
  vim-fugitive

  # not in nixpkgs
  vim-varnish
]
