{
  pkgs,
  nvimCfg,
  inputs,
}: let
  # Choose a base nvim package to override
  neovimPackage = pkgs.neovim-unwrapped; # nixpkgs
  #neovimPackage = inputs.neovim.packages.${pkgs.system}.neovim; # upstream

  # https://github.com/NixOS/nixpkgs/blob/b4d8662c4a479b7641d28fe866b018adf8d8f2e1/pkgs/applications/editors/neovim/utils.nix
  neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
    withPython3 = false;
    withNodeJs = false;
    withRuby = false;
    extraPython3Packages = _: [];
    extraLuaPackages = _: [];

    plugins = nvimCfg.vimPlugins;
    customRC = "";
  };

  wrappedNeovim = pkgs.wrapNeovimUnstable neovimPackage (neovimConfig
    // {
      # neovimConfig has 'wrapperArgs' which sets all the required command line flags to load plugins, treesitter grammars, etc
      wrapRc = false;
    });
in
  pkgs.writeShellApplication {
    name = "nvim";
    runtimeInputs = nvimCfg.runtimePkgs;
    text = ''
      XDG_CONFIG_HOME="${nvimCfg.nvimHome.outPath}" "${wrappedNeovim}/bin/nvim" "$@"
    '';
  }
