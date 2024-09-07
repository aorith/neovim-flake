# Aorith's Neovim Flake

This flake packages Neovim with my custom configuration, including essential tools, linters, and LSP binaries using [Nix/nixpkgs](https://nixos.org/).

## Don't have Nix?

No worries! You can just clone or link the [nvim](./nvim) folder to `~/.config/nvim` to use a standard configuration.

### How does it work?

The Nix wrapper sets an environment variable (`NVIM_NIX=1`). If this variable is present, the Nix-specific Lua configuration is loaded. If not, a standard configuration using [mini.deps](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-deps.md) is loaded instead. This default setup doesn't include the bundled tools, linters, or other extras.

## With Nix

### Run This Configuration

You can run this configuration without installing it on your system. Everything is bundled in the Nix store, except for the files that Neovim creates under `~/.local/...`.

```sh
nix run github:aorith/neovim-flake#default
```

### Development

Run the flake directly from the local folder:

```sh
nix run /path/to/your/local/neovim-flake#default
```

Replace `/path/to/your/local/` with the actual path to your local flake directory.

### Folder Structure

- `nvim/`: Contains the standard Neovim configuration files, similar to what you would find in `~/.config/nvim`. The contents of this directory are copied to the Nix store at build time (ensure all the files are tracked by git).

- `nix/neovim.nix`: Neovim package provided by `nixpkgs` with additional configuration, plugins, and dependencies specified in this flake. Two packages are available: `default` with the neovim configuration embedded in the nix store and `nvim-without-config` which uses the configuration from `~/.config/nvim-nix`, the `nvim` folder of this repository can be symlinked to that path by running the script [link.sh](link.sh).

- `nix/plugins.nix`: This file specifies the Neovim plugins to be included in the configuration. Plugins can be defined directly from `nixpkgs` or included from the flake inputs.

- `nix/packages.nix`: This file lists extra packages that will be made available in Neovim's `$PATH`. These packages might include tools, linters, formatters, language servers, or any other binaries that Neovim plugins or configurations might invoke.

### Installation

#### Nix Profile

For an imperative installation using `nix profile`, use the following command:

```sh
# Remote install
nix profile install github:aorith/neovim-flake#default

# Or install it using a local clone of this repository
nix profile install /path/to/neovim-flake/#default
```

To update, first find the profile number associated with your Neovim flake installation using `nix profile list`, and then use `nix profile upgrade` with the profile number:

```sh
nix profile list # Find the index number for this flake
# Assume the profile number is 2 for the next command
nix profile upgrade 2
```

#### NixOS

To declaratively install this flake in a NixOS configuration, add the package to `environment.systemPackages`. Here's an example configuration snippet:

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

To include it in your Home Manager configuration, add the package to `home.packages`:

```nix
home.packages = [ inputs.neovim-flake.packages.${pkgs.system}.default ];
```
