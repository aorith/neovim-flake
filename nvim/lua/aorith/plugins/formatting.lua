local utils = require("aorith.core.utils")

local opts = {
  formatters_by_ft = {
    jinja = { "djlint", lsp_format = "fallback" },
    htmldjango = { "djlint", lsp_format = "fallback" },

    css = { "prettierd", lsp_format = "prefer" },
    scss = { "prettierd", lsp_format = "prefer" },
    graphql = { "prettierd", lsp_format = "fallback" },
    html = { "prettierd", lsp_format = "prefer" },
    javascript = { "prettierd", lsp_format = "prefer" },
    javascriptreact = { "prettierd", lsp_format = "prefer" },
    json = { "prettierd", lsp_format = "fallback" },
    jsonc = { "prettierd", lsp_format = "fallback" },
    markdown = { "prettierd", lsp_format = "prefer" },
    typescript = { "prettierd", lsp_format = "prefer" },
    typescriptreact = { "prettierd", lsp_format = "prefer" },

    terraform = { "tofu_fmt", "trim_newlines", "trim_whitespace", lsp_format = "fallback" },
    hcl = { "tofu_fmt", "trim_newlines", "trim_whitespace", lsp_format = "fallback" },
    ["terraform-vars"] = { "tofu_fmt", "trim_newlines", "trim_whitespace", lsp_format = "fallback" },

    go = { "goimports", "gofmt", lsp_format = "fallback" }, -- go install golang.org/x/tools/cmd/goimports@latest
    lua = { "stylua", lsp_format = "fallback" },
    nix = { "nixfmt" },
    python = { "ruff_format", "ruff_organize_imports", lsp_format = "first" }, -- ruff_format & ruff_organize_imports  ||  black & isort
    toml = { "taplo", lsp_format = "fallback" },
    yaml = { "prettierd", "trim_newlines", lsp_format = "fallback" }, -- yamlfmt/yamlfix/prettierd (yamlfmt breaks yaml blocks (key: |) sometimes)

    sh = { "shfmt" },
    bash = { "shfmt" },

    templ = { "templ", lsp_format = "last" },

    jsonnet = { "jsonnetfmt" },
  },
  log_level = vim.log.levels.ERROR,
  notify_on_error = true,
}

local xdg_config = vim.fn.getenv("XDG_CONFIG_HOME") ~= vim.NIL and vim.fn.getenv("XDG_CONFIG_HOME") or (vim.fn.getenv("HOME") .. "/.config")
require("conform").formatters.yamlfmt = {
  prepend_args = { "-conf", xdg_config .. "/" .. utils.nvim_appname .. "/extra/yamlfmt" },
}
require("conform").formatters.shfmt = { prepend_args = { "--indent", "4" } }
require("conform").formatters.ruff = { prepend_args = { "--ignore", "F841" } }
require("conform").formatters.stylua = { prepend_args = utils.find_stylua_conf }

require("conform").setup(opts)
