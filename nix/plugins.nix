{
  inputs,
  pkgs,
}: let
  # Function to create a Neovim plugin from a flake input
  mkNvimPlugin = {
    src,
    pname,
  }:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };
in
  with pkgs.vimPlugins; [
    # https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=vimPlugins

    # Plugins can also be lazy loaded with ':packadd! plugin-name' when optional is true:
    #{ plugin = luasnip; optional = true; }

    nvim-treesitter.withAllGrammars
    nvim-treesitter-textobjects
    headlines-nvim

    # format & linting
    conform-nvim
    nvim-lint

    # lsp
    nvim-lspconfig
    neodev-nvim

    # completion & snippets
    luasnip
    nvim-cmp
    cmp_luasnip
    lspkind-nvim
    cmp-nvim-lsp
    cmp-nvim-lsp-signature-help
    cmp-buffer
    cmp-path
    cmp-nvim-lua
    cmp-cmdline
    cmp-cmdline-history

    gitsigns-nvim
    vim-fugitive
    trouble-nvim
    neo-tree-nvim
    vim-sleuth

    telescope-nvim
    telescope-zf-native-nvim

    # Dependencies
    sqlite-lua
    plenary-nvim
    nvim-web-devicons
    vim-repeat

    # Plugins outside of nixpkgs
    (mkNvimPlugin {
      src = inputs.vim-varnish;
      pname = "vim-varnish";
    })
    (mkNvimPlugin {
      src = inputs.mini-nvim;
      pname = "mini-nvim";
    })
  ]
