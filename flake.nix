{
  description = "Aorith's neovim flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    #nixpkgs.url = "github:NixOS/nixpkgs/?rev=e3652e0735fbec227f342712f180f4f21f0594f2";

    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      #inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    # declare external plugins here, name must start with 'plugin_' so they are builded and overlayed automatically
    # then include them in plugins.nix
    "plugin_vim-varnish" = {
      url = "github:varnishcache-friends/vim-varnish";
      flake = false;
    };
    "plugin_vim-fugitive" = {
      url = "github:tpope/vim-fugitive";
      flake = false;
    };
  };

  outputs = inputs: let
    # some helpers
    vimPluginInputs = builtins.filter (s: (builtins.match "plugin_.*" s) != null) (builtins.attrNames inputs); # => [ "plugin_vim-fugitive" "plugin_vim-varnish" ... ]
    vimPluginName = s: builtins.substring 7 (builtins.stringLength s) s; # vimPluginName "plugin_vim-fugitive" => "vim-fugitive"
  in
    # Use flake-utils to automagically create the outputs for various systems: x86_64-linux, aarch64-darwin, ...
    inputs.flake-utils.lib.eachDefaultSystem (system: let
      overlayFlakeInputs = prev: final: let
        # standard plugin builder
        buildVimPlugin = name:
          final.vimUtils.buildVimPluginFrom2Nix {
            pname = vimPluginName name;
            src = builtins.getAttr name inputs;
            version = (builtins.getAttr name inputs).shortRev;
          };
      in {
        # overlay vim plugins
        # the operator "//" combines two attrSets, just test in 'nix repl': { x = 1; } // { x = 2; y = 1; }  ==> { x = 2; y = 1; }
        # so we're appending the plugins or overriding existing ones here
        #
        # 'builtins.listToAttrs ...' creates an attrSet with all the plugin derivations
        # for example => { vim-fugitive = «derivation /nix/store/....vim-fugitive-....drv»; vim-varnish = ...; }
        vimPlugins =
          final.vimPlugins
          // builtins.listToAttrs (map (plugin: {
              name = vimPluginName plugin;
              value = buildVimPlugin plugin;
            })
            vimPluginInputs);
      };

      # apply overlays
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [overlayFlakeInputs];
      };
    in rec {
      apps.default = apps.nvim;
      packages.default = packages.neovimAorith;

      apps.nvim = {
        # apps allow to use 'nix run' directly
        type = "app";
        program = "${packages.neovimAorith}/bin/nvim";
      };

      packages.neovimAorith = let
        #neovimPackage = pkgs.neovim-unwrapped;
        neovimPackage = inputs.neovim.packages.${system}.neovim;
        nvimCfg = import ./config {inherit pkgs;};
      in
        import ./packages/neovim {inherit pkgs neovimPackage nvimCfg;};

      formatter = pkgs.alejandra; # for 'nix fmt'
    });
}
