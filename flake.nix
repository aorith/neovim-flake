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
    nvim = eachSystem (system: import ./nix/neovim.nix {inherit inputs system;});
  in {
    packages = eachSystem (system: {
      # Default package, neovim with the config embedded in the store
      default = nvim.${system}.nvim-with-config;
      # Alternative, uses the config at ~/.config/nvim-nix
      nvim-without-config = nvim.${system}.nvim-without-config;
    });

    # Formatter for 'nix fmt'
    formatter = eachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
