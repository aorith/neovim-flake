# My neovim flake

A flake that bundles neovim together with my configuration and required tools, linters, LSP's binaries, etc.

## Run this configuration

You can run this configuration without installing it in your system, everything is bundled
in the nix store except for the files that neovim creates under `~/.local/...`

```nix
nix run github:aorith/neovim-flake
```

## Development

Run the flake directly from the local folder.

```nix
nix run ~/githome/neovim-flake
```

## Installation

### Nix Profile

Imperative installation using `nix profile`.

```nix
nix profile install github:aorith/neovim-flake
```

### NixOS

Add the default package `environment.systemPackages` (or use home-manager).
This is an (incomplete) example:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    neovim-flake.url = "github:aorith/neovim-flake";
    # ...
  };

  outputs = inputs: {
    nixosConfigurations = {
      trantor = inputs.nixpkgs.lib.nixosSystem
      # ...
        {
          # ...
          modules = [
            ({inputs, ...}: {environment.systemPackages = [inputs.neovim-flake.packages.${system}.default];})
          ];
        };
    };
  };
}
```
