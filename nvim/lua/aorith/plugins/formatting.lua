map(
  "n",
  "<leader>lf",
  function() require("conform").format({ async = false, lsp_format = "fallback", timeout_ms = 5000 }) end,
  { desc = "Format buffer" }
)
map(
  "v",
  "<leader>lf",
  function() require("conform").format({ async = false, lsp_format = "fallback", timeout_ms = 5000 }) end,
  { desc = "Format buffer" }
)

local utils = require("aorith.core.utils")

local opts = {
  formatters_by_ft = {
    jinja = { "djlint" },
    htmldjango = { "djlint" },

    css = { "prettierd" },
    scss = { "prettierd" },
    graphql = { "prettierd" },
    html = { "prettierd" },
    javascript = { "prettierd" },
    javascriptreact = { "prettierd" },
    json = { "prettierd" },
    jsonc = { "prettierd" },
    markdown = { "prettierd" },
    terraform = { "terraform_fmt", "trim_newlines", "trim_whitespace" },
    hcl = { "terraform_fmt", "trim_newlines", "trim_whitespace" },
    typescript = { "prettierd" },
    typescriptreact = { "prettierd" },

    go = { "goimports", "gofmt" }, -- go install golang.org/x/tools/cmd/goimports@latest
    lua = { "stylua" },
    nix = { "nixpkgs_fmt" },
    python = { "ruff_format", "ruff_organize_imports" }, -- ruff_format & ruff_organize_imports  ||  black & isort
    toml = { "taplo" },
    yaml = { "yamlfmt", "trim_newlines" }, -- yamlfmt/yamlfix/prettierd

    sh = { "shfmt" },
    bash = { "shfmt" },

    templ = { "templ" },
  },
  log_level = vim.log.levels.ERROR,
  notify_on_error = true,
}

local xdg_config = vim.fn.getenv("XDG_CONFIG_HOME") ~= vim.NIL and vim.fn.getenv("XDG_CONFIG_HOME")
  or (vim.fn.getenv("HOME") .. "/.config")
require("conform").formatters.yamlfmt = {
  prepend_args = { "-conf", xdg_config .. "/" .. utils.nvim_appname .. "/extra/yamlfmt" },
}
require("conform").formatters.shfmt = { prepend_args = { "--indent", "4" } }
require("conform").formatters.ruff = { prepend_args = { "--ignore", "F841" } }
require("conform").formatters.stylua = { prepend_args = utils.find_stylua_conf }

require("conform").setup(opts)
