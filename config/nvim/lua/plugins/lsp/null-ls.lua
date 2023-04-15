local utils = require("core.utils")
local null_ls = require("null-ls")
local null_ls_utils = require("null-ls.utils")

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

-- Null-Ls sources
-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
local null_ls_sources = {
  code_actions.gitsigns,
  code_actions.refactoring,
  diagnostics.todo_comments,
  diagnostics.trail_space,
  null_ls.builtins.hover.printenv,
  null_ls.builtins.hover.dictionary,

  -- shell
  code_actions.shellcheck.with({ command = "@shellcheck@/bin/shellcheck" }),
  diagnostics.shellcheck.with({ command = "@shellcheck@/bin/shellcheck" }),
  formatting.shfmt.with({
    command = "@shfmt@/bin/shfmt",
    extra_args = { "--indent", "4" },
    filetypes = { "sh", "bash" },
  }),

  -- python
  formatting.black.with({ command = "@black@/bin/black" }),
  --[[ TODO: https://github.com/charliermarsh/ruff/issues/1904
  formatting.ruff.with({
    command = "@ruff@/bin/ruff",
    extra_args = { "--config", utils.get_pyproject_path() },
  }),
  --]]
  diagnostics.ruff.with({
    command = "@ruff@/bin/ruff",
    extra_args = { "--config", utils.get_pyproject_path() },
  }),

  -- mixins
  formatting.prettier.with({ command = "@prettier@/bin/prettier" }),
  formatting.jq.with({ command = "@jq@/bin/jq" }),
  formatting.yamlfmt.with({ command = "@yamlfmt@/bin/yamlfmt" }),
  formatting.stylua.with({
    command = "@stylua@/bin/stylua",
    extra_args = { "--config-path", vim.fn.getenv("XDG_CONFIG_HOME") .. "/" .. utils.nvim_appname .. "/stylua.toml" },
  }),
  diagnostics.tidy.with({ command = "@tidy@/bin/tidy" }),
  diagnostics.yamllint.with({ command = "@yamllint@/bin/yamllint" }),
  diagnostics.golangci_lint.with({ command = "@golangci_lint@/bin/golangci-lint" }),

  -- terraform
  diagnostics.terraform_validate.with({ command = "@terraform@/bin/terraform" }),
  formatting.terraform_fmt.with({ command = "@terraform@/bin/terraform" }),

  -- nix formatter https://github.com/kamadorueda/alejandra
  formatting.alejandra.with({ command = "@alejandra@/bin/alejandra" }),

  -- editorconfig
  diagnostics.editorconfig_checker.with({ command = "@editorconfig_checker@/bin/editorconfig-checker" }),
}

null_ls.setup({
  root_dir = null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git"),
  debug = false,
  sources = null_ls_sources,
})
