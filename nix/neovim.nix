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
    withSQLite = false;
  };

  # List of Neovim plugins
  allPlugins = import ./plugins.nix { inherit inputs pkgs opts; };

  # Packages like lsps, linters or formatters ...
  packages = import ./packages.nix { inherit pkgs; };

  # Consolidate all the packages in the same PATH to avoid multiple entries
  externalPackages = pkgs.buildEnv {
    name = "nvim-external-pkgs";
    paths = packages.packages;
    pathsToLink = [ "/bin" ];
  };

  nvimHome = pkgs.stdenv.mkDerivation {
    name = "nvim-config";
    src = ../nvim;
    installPhase = ''
      mkdir -p "$out/${appName}"
      shopt -s dotglob
      cp -r * "$out/${appName}/"
    '';
  };
in
pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
  withPython3 = false;
  withNodeJs = false;
  withRuby = false;
  extraPython3Packages = packages.extraPython3Packages;
  extraLuaPackages = packages.extraLuaPackages;
  plugins = allPlugins;
  luaRcContent = "";
  wrapRc = false;

  wrapperArgs = lib.escapeShellArgs (
    [
      "--prefix"
      "PATH"
      ":"
      (lib.makeBinPath [ externalPackages ])
      "--set"
      "NVIM_NIX"
      "1"
      "--set"
      "NVIM_APPNAME"
      appName
    ]
    ++ lib.optionals with-config [
      "--set"
      "XDG_CONFIG_HOME"
      nvimHome.outPath
    ]
    ++ lib.optionals opts.withSQLite [
      "--set"
      "LIBSQLITE"
      "${pkgs.sqlite.out}/lib/libsqlite3.${if pkgs.stdenv.isDarwin then "dylib" else "so"}"
    ]
  );
}
