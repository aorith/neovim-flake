{
  description = "Aorith's neovim flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    #nixpkgs.url = "github:NixOS/nixpkgs/?rev=e3652e0735fbec227f342712f180f4f21f0594f2";

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
    {
      # the name 'vimPlugins' here is arbitrary and only matters in the callPackage of nvimCfg
      overlays.vimPlugins = final: prev: let
        # standard plugin builder
        buildVimPlugin = name:
          final.vimUtils.buildVimPluginFrom2Nix {
            pname = vimPluginName name;
            src = builtins.getAttr name inputs;
            version = (builtins.getAttr name inputs).shortRev;
          };
      in {
        # overlay vimPlugins, this allows to use pkgs.vimPlugins with our additional plugins
        # the operator "//" combines two attrSets, just test in 'nix repl': { x = 1; } // { x = 2; y = 1; }  ==> { x = 2; y = 1; }
        # so we're appending the plugins or overriding existing ones here
        #
        # 'builtins.listToAttrs ...' creates an attrSet with all the plugin derivations
        # for example => { vim-fugitive = «derivation /nix/store/....vim-fugitive-....drv»; vim-varnish = ...; }
        vimPlugins =
          prev.vimPlugins
          // builtins.listToAttrs (map (plugin: {
              name = vimPluginName plugin;
              value = buildVimPlugin plugin;
            })
            vimPluginInputs);
      };

      # https://nixos.org/manual/nixpkgs/unstable/#sec-overlays-definition
      # Overlays are Nix functions which accept two arguments, conventionally called self and super , and return a set of packages.
      #
      #  The first argument (self) corresponds to the final package set.
      #  You should use this set for the dependencies of all packages specified in your overlay.
      #
      #  The second argument (super) corresponds to the result of the evaluation of the previous stages of Nixpkgs.
      #  It does not contain any of the packages added by the current overlay, nor any of the following overlays.
      #  This set should be used either to refer to packages you wish to override, or to access functions defined in Nixpkgs.

      overlays.default = final: prev: let
        pkgs = import inputs.nixpkgs {
          system = prev.system;
          overlays = [inputs.self.overlays.vimPlugins];
        };
        # generate the nvim configuration
        # pkgs is extended with our custom vimPlugins, for extending in the nix repl you can do:
        #   pkgs = (inputs.nixpkgs.legacyPackages.x86_64-linux.extend outputs.overlays.vimPlugins)
        # and you'll see that now pkgs contains 'vim-varnish': 'pkgs.vimPlugins.vim-varnish'
        nvimCfg = final.callPackage ./config {inherit pkgs;};
      in {
        # finally use callPackage to create the neovim derivation
        aorith.neovim = final.callPackage ./packages/neovim {inherit pkgs inputs nvimCfg;};
      };
    }
    // # Use flake-utils to automagically create the outputs for various systems: x86_64-linux, aarch64-darwin, ...
    inputs.flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import inputs.nixpkgs {
        inherit system;
        # overlay the overlays from this same flake
        overlays = [inputs.self.overlays.default];
      };
    in rec {
      apps.default = apps.nvim;
      packages.default = packages.neovimAorith;

      apps.nvim = {
        # apps allow to use 'nix run' directly
        type = "app";
        program = "${packages.neovimAorith}/bin/nvim";
      };

      # the real package is now overlayed under 'pkgs.aorith.neovim', you can check this in a repl:
      #  'pkgs = (inputs.nixpkgs.legacyPackages.x86_64-linux.extend outputs.overlays.default)'
      #  'pkgs.aorith.neovim'
      packages.neovimAorith = pkgs.aorith.neovim;

      formatter = pkgs.alejandra; # for 'nix fmt'
    });
}
