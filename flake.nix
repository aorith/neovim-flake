{
  description = "Aorith's neovim flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Plugins built from source outside of nixpkgs
    # vim-varnish.url = "github:varnishcache-friends/vim-varnish";
    # vim-varnish.flake = false;
  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
      treefmt-nix,
      ...
    }@inputs:
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);
      treefmtEval = eachSystem (
        system: treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} ./treefmt.nix
      );
    in
    {
      packages = eachSystem (system: {
        # Default package, neovim with the config embedded in the store
        default = import ./nix/neovim.nix { inherit inputs system; };
        # Alternative, uses the config at ~/.config/nvim-nix
        vanilla = import ./nix/neovim.nix {
          inherit inputs system;
          with-config = false;
        };
      });

      # for `nix fmt`
      formatter = eachSystem (system: treefmtEval.${system}.config.build.wrapper);
      # for `nix flake check`
      checks = eachSystem (system: {
        formatting = treefmtEval.${system}.config.build.check self;
      });
    };
}
