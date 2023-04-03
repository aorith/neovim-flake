{pkgs}: {
  # derivation with all the configs for nvim (AKA ~/.config/nvim)
  nvimHome = pkgs.stdenv.mkDerivation {
    name = "nvim-home";
    src = ./.;
    installPhase = ''
      mkdir -p $out/nvim
      cp -r ./nvim/* $out/nvim/

      # https://nixos.org/manual/nixpkgs/stable/#fun-substituteAll
      # some lua files with pkg substitutions
      cp ${pkgs.substituteAll {
        src = ./nvim/lua/plugins/lsp/null-ls.lua;

        alejandra = pkgs.alejandra;
        golangci_lint = pkgs.golangci-lint;
        jq = pkgs.jq;
        prettier = pkgs.nodePackages.prettier;
        ruff = pkgs.ruff;
        shellcheck = pkgs.shellcheck;
        shfmt = pkgs.shfmt;
        stylua = pkgs.stylua;
        terraform = pkgs.terraform;
        tidy = pkgs.html-tidy;
        yamlfmt = pkgs.yamlfmt;
        yamllint = pkgs.yamllint;
      }} "$out/nvim/lua/plugins/lsp/null-ls.lua"

      cp ${pkgs.substituteAll {
        src = ./nvim/lua/plugins/lsp/servers.lua;

        gopls = pkgs.gopls;
        lua_ls = pkgs.lua-language-server;
        nil = pkgs.nil;
        pyright = pkgs.nodePackages.pyright;
        sqls = pkgs.sqls;
        terraformls = pkgs.terraform-ls;
        tflint = pkgs.tflint;
        typescript = pkgs.nodePackages.typescript-language-server;
        yaml_language_server = pkgs.nodePackages.yaml-language-server;
      }} "$out/nvim/lua/plugins/lsp/servers.lua"
    '';
  };

  vimPlugins = import ./vimPlugins.nix {inherit pkgs;};
  runtimePkgs = import ./runtimePkgs.nix {inherit pkgs;};
}
