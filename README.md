# My neovim flake

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

TODO
