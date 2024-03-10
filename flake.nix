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

  outputs = {nixpkgs, ...} @ inputs: let
    eachSystem = nixpkgs.lib.genAttrs ["aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux"];

    # Import Neovim overlay
    neovim-overlay = import ./nix/neovim-overlay.nix {inherit inputs;};

    # Pkgs with the neovim overlay
    # it will contain each system: 'pkgs.x86_64-linux, pkgs.aarch64-linux, ...'
    pkgs = eachSystem (system:
      import nixpkgs {
        inherit system;
        overlays = [neovim-overlay];
      });
  in {
    # Overlay for NixOS configuration
    overlays.default = neovim-overlay;

    # Default package for 'nix run .'
    packages = eachSystem (system: {
      default = pkgs.${system}.nvim-aorith;
      nvim = pkgs.${system}.nvim-aorith;
    });

    # Formatter for 'nix fmt'
    # I don't need to use the overlaid pkgs, so just regular one from legacyPackages
    formatter = eachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
