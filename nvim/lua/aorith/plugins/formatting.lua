map(
  "n",
  "<leader>lf",
  function() require("conform").format({ async = false, lsp_fallback = true, timeout_ms = 5000 }) end,
  { desc = "Format buffer" }
)
map(
  "v",
  "<leader>lf",
  function() require("conform").format({ async = false, lsp_fallback = true, timeout_ms = 5000 }) end,
  { desc = "Format buffer" }
)

local utils = require("aorith.core.utils")

local opts = {
  formatters_by_ft = {
    jinja = { "djlint" },
    htmldjango = { "djlint" },

    css = { "prettierd" },
    graphql = { "prettierd" },
    html = { "prettierd" },
    javascript = { "prettierd" },
    javascriptreact = { "prettierd" },
    json = { "prettierd" },
    jsonc = { "prettierd" },
    markdown = { "prettierd" },
    terraform = { "terraform_fmt", "trim_newlines", "trim_whitespace" },
    typescript = { "prettierd" },
    typescriptreact = { "prettierd" },

    yaml = { "yamlfmt" }, -- yamlfmt/yamlfix/prettierd
    go = { "goimports", "gofmt" },
    lua = { "stylua" },
    nix = { "alejandra" },
    python = { "black", "isort" },
    xml = { "xmlformat" },

    sh = { "shfmt" },
    bash = { "shfmt" },
  },
  log_level = vim.log.levels.ERROR,
  notify_on_error = true,
}

---@diagnostic disable: param-type-mismatch
vim.list_extend(require("conform.formatters.shfmt").args, { "--indent", "4" })
vim.list_extend(require("conform.formatters.ruff").args, { "--ignore", "F841" }) -- avoid ruff deleting unused variables
vim.list_extend(
  require("conform.formatters.stylua").args,
  { "--config-path", vim.fn.getenv("XDG_CONFIG_HOME") .. "/" .. utils.nvim_appname .. "/stylua.toml" }
)

require("conform").setup(opts)
