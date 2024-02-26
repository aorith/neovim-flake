{
  description = "Aorith's neovim flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # External plugins
    vim-varnish.url = "github:varnishcache-friends/vim-varnish";
    vim-varnish.flake = false;

    mini-nvim.url = "github:echasnovski/mini.nvim";
    mini-nvim.flake = false;
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: let
      # Import Neovim overlay
      neovim-overlay = import ./nix/neovim-overlay.nix {inherit inputs;};
      pkgs = import nixpkgs {
        inherit system;
        overlays = [neovim-overlay];
      };

      # Neovim package
      nvim = pkgs.nvim-aorith;
    in {
      packages = {
        default = nvim;
        nvim = nvim;
      };

      # Formatter for 'nix fmt'
      formatter = pkgs.alejandra;

      # Overlay for NixOS configuration
      overlays.default = neovim-overlay;
    });
}
