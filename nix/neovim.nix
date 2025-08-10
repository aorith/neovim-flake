{
  inputs,
  system,
  with-config ? true,
  ...
}:
let
  pkgs = import inputs.nixpkgs { inherit system; };
  lib = pkgs.lib;
  appName = "nvim-nix";

  # Optionals
  opts = {
    withSQLite = false; # I dont use any plugin that requires sqlite.lua atm
  };

  # List of Neovim plugins
  allPlugins = import ./plugins.nix { inherit inputs pkgs opts; };

  # Packages
  packages = import ./packages.nix { inherit pkgs; };

  # Extra packages in $PATH
  # Grouped in buildEnv to avoid multiple $PATH entries
  externalPackages = pkgs.buildEnv {
    name = "nvim-external-pkgs";
    paths = packages.packages;
    pathsToLink = [ "/bin" ];
  };

  # Configuration for the Neovim wrapper
  neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
    withPython3 = false;
    withNodeJs = false;
    withRuby = false;
    extraPython3Packages = packages.extraPython3Packages;
    extraLuaPackages = packages.extraLuaPackages; # Additional lua packages (from luarocks, ...)

    plugins = allPlugins;
    customRC = "";
    wrapRc = false;
  };

  # Neovim config directory (init.lua, lua/, ...)
  nvimHome = pkgs.stdenv.mkDerivation {
    name = "nvim-config";
    src = ../nvim;
    installPhase = ''
      mkdir -p "$out/${appName}"
      shopt -s dotglob # Include hidden files in glob patterns
      cp -r * "$out/${appName}/"
    '';
  };

  # Additional arguments for the Neovim wrapper
  extraMakeWrapperArgs = builtins.concatStringsSep " " (
    [
      ''--prefix PATH : "${lib.makeBinPath [ externalPackages ]}"''
      ''--set NVIM_NIX "1"''
      ''--set NVIM_APPNAME "${appName}"''
    ]
    ++ (lib.optionals with-config [ ''--set XDG_CONFIG_HOME "${nvimHome.outPath}"'' ])
    ++ (lib.optionals opts.withSQLite [
      ''--set LIBSQLITE "${pkgs.sqlite.out}/lib/libsqlite3.${
        if pkgs.stdenv.isDarwin then "dylib" else "so"
      }"''
    ])
  );
in
pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (
  neovimConfig
  // {
    wrapperArgs = lib.escapeShellArgs neovimConfig.wrapperArgs + " " + extraMakeWrapperArgs;
  }
)
