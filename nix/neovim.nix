{
  inputs,
  system,
  ...
}: let
  pkgs = import inputs.nixpkgs {inherit system;};
  appName = "nvim-nix";

  # List of Neovim plugins
  allPlugins = import ./plugins.nix {inherit inputs pkgs;};

  # Extra packages in $PATH
  # Grouped in buildEnv to avoid multiple $PATH entries
  externalPackages = pkgs.buildEnv {
    name = "nvim-external-pkgs";
    paths = import ./packages.nix {inherit pkgs;};
  };

  # Configuration for the Neovim wrapper
  neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
    withPython3 = false;
    withNodeJs = false;
    withRuby = false;
    extraPython3Packages = _: [];
    extraLuaPackages = _: []; # Additional lua packages (from luarocks, ...)

    plugins = allPlugins;
    customRC = "";
  };

  # Neovim config directory (init.lua, lua/, ...)
  nvimHome = pkgs.stdenv.mkDerivation {
    name = "nvim-config";
    src = ../.;
    installPhase = ''
      mkdir -p $out
      cp -r nvim "$out/${appName}"
    '';
  };

  # Additional arguments for the Neovim wrapper
  extraMakeWrapperArgs = builtins.concatStringsSep " " [
    ''--prefix PATH : "${pkgs.lib.makeBinPath [externalPackages]}"''
    ''--set NVIM_APPNAME "${appName}"''
    ''--set LIBSQLITE_CLIB_PATH "${pkgs.sqlite.out}/lib/libsqlite3.so"''
    ''--set LIBSQLITE "${pkgs.sqlite.out}/lib/libsqlite3.so"''
  ];
in {
  nvim-with-config = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (neovimConfig
    // {
      wrapperArgs = pkgs.lib.escapeShellArgs neovimConfig.wrapperArgs + " " + extraMakeWrapperArgs + " " + ''--set XDG_CONFIG_HOME "${nvimHome.outPath}"'';
      wrapRc = false;
    });
  nvim-without-config = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (neovimConfig
    // {
      wrapperArgs = pkgs.lib.escapeShellArgs neovimConfig.wrapperArgs + " " + extraMakeWrapperArgs;
      wrapRc = false;
    });
}
