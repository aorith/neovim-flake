{pkgs}:
with pkgs; [
  # Dependencies
  fd
  git
  ripgrep
  sqlite

  # Formatters
  alejandra
  black
  gotools # goimports
  isort
  prettierd
  ruff
  shfmt
  stylua
  xmlformat
  #yamlfix
  yamlfmt

  # Linters
  djlint
  golangci-lint
  shellcheck
  typos
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
