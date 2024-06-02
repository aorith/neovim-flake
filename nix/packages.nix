{ pkgs }:
{
  packages =
    with pkgs;
    [
      # Dependencies
      fd
      git
      ripgrep

      # Formatters
      black
      gotools # goimports
      isort
      nixfmt-rfc-style
      prettierd
      ruff
      shfmt
      stylua
      taplo
      xmlformat
      yamlfmt

      # Linters
      djlint
      golangci-lint
      shellcheck
      typos
      vale
      yamllint

      # LSP
      lua-language-server
      nil
      nodePackages.bash-language-server
      gopls
      sqls
      yaml-language-server
      terraform-ls
      marksman
      ruff-lsp
      nodePackages.pyright
      nodePackages.typescript-language-server
      vscode-langservers-extracted # html, css, ...
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
      pkgs.fswatch # https://github.com/neovim/neovim/pull/27347
    ];

  # Extra lua packages to install, where package is 'xxx' in lua51Packages.xxx
  extraLuaPackages =
    ps: with ps; [
      jsregexp # required by luasnip
    ];

  # Extra python packages
  extraPython3Packages = _: [ ];

  vale_setup = pkgs.callPackage ./vale.nix { inherit pkgs; };
}
