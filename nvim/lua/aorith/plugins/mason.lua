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
  "ansible-lint",
  "djlint",
  "golangci-lint",
  "nixpkgs-fmt",
  "proselint",
  "shellcheck",
  "tflint",
  "typos",
  "yamllint",

  -- LSP
  "basedpyright",
  "bash-language-server",
  "css-lsp",
  "gopls",
  "html-lsp",
  "lua-language-server",
  "marksman",
  "nil",
  "ruff-lsp",
  "templ",
  "terraform-ls",
  "typescript-language-server",
  "yaml-language-server",
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
