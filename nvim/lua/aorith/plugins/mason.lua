require("mason").setup()
require("mason-lspconfig").setup()

local tools = {
  -- Formatters
  "black",
  "goimports",
  "isort",
  "prettierd",
  "ruff",
  "shfmt",
  "stylua",
  "taplo",
  "xmlformatter",
  "yamlfix",
  "yamlfmt",

  -- Linters
  "djlint",
  "golangci-lint",
  "nixpkgs-fmt",
  "proselint",
  "shellcheck",
  "typos",
  "vale",
  "yamllint",

  -- LSP
  "lua-language-server",
  "nil",
  "bash-language-server",
  "gopls",
  "sqlls",
  "yaml-language-server",
  "terraform-ls",
  "marksman",
  "ruff-lsp",
  "pyright",
  "typescript-language-server",
  "html-lsp",
  "css-lsp",
}

vim.schedule(function()
  local mr = require("mason-registry")

  local function ensure_installed()
    for _, tool in ipairs(tools) do
      local p = mr.get_package(tool)
      if not p:is_installed() then p:install() end
    end
  end

  if mr.refresh then
    mr.refresh(ensure_installed)
  else
    ensure_installed()
  end
end)
