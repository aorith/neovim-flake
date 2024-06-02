{
  description = "Aorith's neovim flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # External plugins
    vim-varnish.url = "github:varnishcache-friends/vim-varnish";
    vim-varnish.flake = false;

    mini-nvim.url = "github:echasnovski/mini.nvim";
    mini-nvim.flake = false;
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      eachSystem = nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    in
    {
      packages = eachSystem (system: {
        # Default package, neovim with the config embedded in the store
        default = import ./nix/neovim.nix { inherit inputs system; };
        # Alternative, uses the config at ~/.config/nvim-nix
        nvim-without-config = import ./nix/neovim.nix {
          inherit inputs system;
          with-config = false;
        };
      });

      # Formatter for 'nix fmt'
      formatter = eachSystem (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
    };
}
