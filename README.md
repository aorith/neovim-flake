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

Update using `nix profile upgrade <NUMBER>`.

```nix
nix profile list | grep neovim
# 2 github:aorith/neovim-flake#packages.aarch64-darwin.default github:aorith/neovim-flake/3454e487b2a428694c84d6617cf1f1ea95aa8270#packages.aarch64-darwin.default /nix/store/p4rlazrss7691pxr1hfgd9qfhs0wdv6d-nvim

nix profile upgrade 2
```

### NixOS

Add the default package `environment.systemPackages`.
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

Or add the overlay to your `nixpkgs` and include `pkgs.aorith.neovim` in `environment.systemPackages`:

```nix
    modules = [
      ({pkgs, ...}: {nixpkgs.overlays = [inputs.neovim-flake.overlays.default];})
      ({pkgs, ...}: {environment.systemPackages = [pkgs.aorith.neovim];})
    ];
```

You can override this flake `nixpkgs` input with `neovim-flake.inputs.nixpkgs.follows = "nixpkgs";` to use your pinned version of `nixpkgs`.

### Home Manager

Add it to `home.packages`.

```nix
home.packages = [ inputs.neovim-flake.packages.${pkgs.system}.default ];
```
