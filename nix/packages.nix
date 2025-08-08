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
      go-jsonnet # jsonnetfmt
      gotools # goimports
      isort
      nixfmt
      prettierd
      ruff
      shfmt
      stylua
      taplo
      xmlformat
      yamlfmt

      # Linters
      ansible-lint
      djlint
      golangci-lint
      shellcheck
      tflint
      typos
      yamllint

      # LSP
      basedpyright
      bash-language-server
      gopls
      lua-language-server
      marksman
      nil
      rust-analyzer
      templ
      terraform-ls
      tofu-ls
      typescript-language-server
      vscode-langservers-extracted # html, css, ...
      yaml-language-server
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
}
