# Aorith's Neovim Flake

This flake packages Neovim with my custom configuration, including tools, linters, and LSP binaries using [Nix/nixpkgs](https://nixos.org/).
It does also work without Nix, since I use it on machines that do not have or cannot install Nix.
The Nix wrapper sets an environment variable (`NVIM_NIX=1`). If this variable is present, the Nix-specific Lua configuration is loaded.

It does not manage all the plugins with Nix, only the ones that break on NixOS are installed with it, like treesitter and its parsers, everything else is managed using [mini.deps](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-deps.md).

## With Nix

It has two flavours, both of them set the variable `NVIM_APPNAME` to `nvim-nix` (the nvim wrapper does):

- `#default`: configuration is copied over to the nix-store, and you can run it on any machine with Nix without symlinking it to `~/.config`
- `#nvim-without-config`: the configuration is loaded from `~/.config/$NVIM_APPNAME`, this is what I usually use as it allows modifying the config on the fly, so I execute `./link.sh` as part of the bootstrap to link the config on a new machine

### Folder Structure

- `nvim/`: Contains the standard Neovim configuration files, similar to what you would find in `~/.config/nvim`.
- `nix/neovim.nix`: Builds the actual package and sets the required environment vars so Neovim can find the tools/linters and plugins.
- `nix/plugins.nix`: Plugins to be included in the configuration, either from `nixpkgs` or as flake inputs.
- `nix/packages.nix`: Extra packages that will be made available in Neovim's `$PATH`.

### Execution options

```sh
# One shot
nix run github:aorith/neovim-flake#default
nix run github:aorith/neovim-flake#nvim-without-config

# Development
nix run /path/to/your/local/neovim-flake#default
nix run /path/to/your/local/neovim-flake#nvim-without-config
```

### Installation

#### Nix Profile

```sh
# Remote install
nix profile install github:aorith/neovim-flake#default
nix profile install github:aorith/neovim-flake#nvim-without-config

# Or install it using a local clone of this repository
nix profile install /path/to/neovim-flake/#default
nix profile install /path/to/neovim-flake/#nvim-without-config
```

To update, first find the profile number associated with it using `nix profile list`, and then use `nix profile upgrade` with the profile number:

```sh
nix profile list # Find the name for this flake
# Assuming the name is 'nvim-without-config'
nix profile upgrade 'nvim-without-config'
# Or upgrade everything
nix profile upgrade --all
```

#### NixOS

Add the flake and the package to `environment.systemPackages`. Either `default` or `nvim-without-config`, here's an example:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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

#### Home Manager

Same thing as with NixOS but under `home.packages`:

```nix
home.packages = [ inputs.neovim-flake.packages.${pkgs.system}.default ];
```
