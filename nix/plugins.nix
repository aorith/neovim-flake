{
  inputs,
  pkgs,
  opts,
}:
let
  # Function to create a vim plugin from a flake input
  mkVimPlugin =
    { src, pname }:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };

  # NOTE: this is for luaPackages: https://github.com/NixOS/nixpkgs/blob/36dcdaf8f6b0e0860721ecd4aada50c0cccc3cfd/pkgs/applications/editors/neovim/build-neovim-plugin.nix#L11-L12
  # pkgs.neovimUtils.buildNeovimPlugin

  # Merge nvim-treesitter parsers together to reduce vim.api.nvim_list_runtime_paths()
  nvim-treesitter-grammars = pkgs.symlinkJoin {
    name = "nvim-treesitter-grammars";
    paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
  };
in
with pkgs.vimPlugins;
[
  # https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=vimPlugins

  # Plugins can also be lazy loaded with ':packadd! plugin-name' when optional is true:
  #{ plugin = luasnip; optional = true; }

  # themes
  kanagawa-nvim

  #nvim-treesitter.withAllGrammars
  nvim-treesitter
  nvim-treesitter-grammars
  nvim-treesitter-textobjects
  nvim-treesitter-context

  # format & linting
  conform-nvim
  nvim-lint

  # lsp
  nvim-lspconfig
  lazydev-nvim

  neo-tree-nvim
  undotree
  vim-sleuth
  aerial-nvim
  diffview-nvim

  # telescope-nvim
  # telescope-zf-native-nvim

  # Dependencies
  plenary-nvim

  # Plugins outside of nixpkgs
  (mkVimPlugin {
    src = inputs.vim-varnish;
    pname = "vim-varnish";
  })
  (mkVimPlugin {
    src = inputs.mini-nvim;
    pname = "mini-nvim";
  })
]
++ (pkgs.lib.optionals opts.withSQLite [ sqlite-lua ])
