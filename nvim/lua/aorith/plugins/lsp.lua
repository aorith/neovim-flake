-- Log level
vim.lsp.set_log_level(vim.log.levels.ERROR)

-- Diagnostics
vim.diagnostic.config({
  signs = { priority = 9999 },
  underline = true,
  update_in_insert = false, -- false so diags are updated on InsertLeave
  virtual_text = { current_line = true, severity = { min = "INFO" } },
  -- virtual_text = { current_line = true, severity = { min = "INFO", max = "WARN" } },
  -- virtual_lines = { current_line = true, severity = { min = "ERROR" } },
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = true,
    header = "",
  },
})

local custom_on_attach = function(client, bufnr)
  -- disable some more capabilities
  if client.name == "pylsp" then
    client.server_capabilities.renameProvider = false
    client.server_capabilities.rename = false
  end

  -- disable semantic tokens
  -- currently it messes the highlighting, when I open a tf file it changes after a few seconds
  if client.name == "terraformls" then client.server_capabilities.semanticTokensProvider = nil end

  -- -- Set up 'mini.completion' LSP part of completion
  vim.bo[bufnr].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"

  -- notify attachment
  ---@diagnostic disable-next-line: param-type-mismatch
  -- vim.notify(client.name .. " started", vim.log.levels.INFO, {
  --   -- title = "Attaching LSP",
  --   timeout = 3000,
  -- })
end

local capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {})
local util = require("lspconfig.util")

-- Use same capabilities and custom_on_attach on every lsp
vim.lsp.config("*", {
  capabilities = capabilities,
  on_attach = custom_on_attach,
})

vim.lsp.enable({
  "tofu_ls",
  "nil_ls",
  "bashls",
  "gopls",
  "yamlls",
  "marksman",
  "lua_ls",
  "basedpyright",
  "ts_ls",
  "eslint",
  "html",
  "cssls",
  "templ",
  "zk",
  "jsonnet_ls",
  "helm_ls",
  -- "kcl",
  "cue",
  "rust_analyzer",
})

vim.lsp.config("tofu_ls", {
  filetypes = { "terraform", "terraform-vars", "opentofu", "opentofu-vars" },
})

vim.lsp.config("nil_ls", {
  settings = { ["nil"] = { formatting = { command = { "nixfmt" } } } },
})

vim.lsp.config("bashls", {
  capabilities = capabilities,
  on_attach = custom_on_attach,
})

vim.lsp.config("gopls", {
  capabilities = capabilities,
  on_attach = custom_on_attach,
})

vim.lsp.config("yamlls", {
  on_init = function() require("aorith.core.yaml_schema").get_client() end,
  capabilities = capabilities,
  on_attach = custom_on_attach,

  settings = {
    redhat = { telemetry = { enabled = false } },

    yaml = {
      validate = true,
      format = { enable = true },
      keyOrdering = false,
      hover = true,
      completion = true,

      schemaStore = {
        enable = false,
        url = "https://www.schemastore.org/api/json/catalog.json",
      },

      -- schemas detected by filename
      schemas = {
        ["https://json.schemastore.org/kustomization.json"] = "kustomization.{yml,yaml}",
        ["https://raw.githubusercontent.com/docker/compose/master/compose/config/compose_spec.json"] = "{docker-,}compose*.{yml,yaml}",
        ["https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json"] = "argocd-application.{yml,yaml}",
        ["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*.{yml,yaml}",
      },

      -- custom option to select schemas by name with 'YAMLSchemaSelect' (aorith.core.yaml_schema)
      -- [<uri>] = <name>
      custom_schemas = {
        ["kubernetes"] = "kubernetes",
        ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.25.16-standalone-strict/all.json"] = "k8s-1.25.16",
        ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.31.4-standalone-strict/all.json"] = "k8s-1.31.4",
      },
    },
  },
})

vim.lsp.config("marksman", {
  capabilities = capabilities,
  on_attach = custom_on_attach,
})

vim.lsp.config("lua_ls", {
  on_attach = function(client, bufnr)
    custom_on_attach(client, bufnr)
    -- Reduce unnecessarily long list of completion triggers for better
    -- 'mini.completion' experience
    client.server_capabilities.completionProvider.triggerCharacters = { ".", ":" }
  end,
  capabilities = capabilities,

  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        -- Setup your lua path
        path = vim.split(package.path, ";"),
      },
      diagnostics = {
        -- Get the language server to recognize common globals
        globals = { "vim" },
        disable = { "need-check-nil" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        -- Don't analyze code from submodules
        ignoreSubmodules = true,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

vim.lsp.config("basedpyright", {
  capabilities = capabilities,
  on_attach = custom_on_attach,
  settings = {
    {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          useLibraryCodeForTypes = true,
        },
      },
    },
  },
})

vim.lsp.config("ts_ls", {
  capabilities = capabilities,
  on_attach = custom_on_attach,
})

vim.lsp.config("eslint", {
  capabilities = capabilities,
  on_attach = custom_on_attach,
})

vim.lsp.config("html", {
  capabilities = capabilities,
  on_attach = custom_on_attach,
})

vim.lsp.config("cssls", {
  capabilities = capabilities,
  on_attach = custom_on_attach,
})

vim.lsp.config("templ", {
  capabilities = capabilities,
  on_attach = custom_on_attach,
})

vim.lsp.config("zk", {
  capabilities = capabilities,
  on_attach = custom_on_attach,
})

-- go install github.com/grafana/jsonnet-language-server@latest
vim.lsp.config("jsonnet_ls", {
  capabilities = capabilities,
  on_attach = custom_on_attach,
})

vim.lsp.config("helm_ls", {
  capabilities = capabilities,
  on_attach = custom_on_attach,
  settings = {
    ["helm-ls"] = {
      yamlls = {
        path = "yaml-language-server",
      },
    },
  },
})

vim.lsp.config("kcl", {
  capabilities = capabilities,
  on_attach = custom_on_attach,
  cmd = { "kcl-language-server" },
  filetypes = { "kcl" },
  root_dir = util.root_pattern("kcl.mod"),
})

vim.lsp.config("cue", {
  capabilities = capabilities,
  on_attach = custom_on_attach,
})

vim.lsp.config("rust_analyzer", {
  capabilities = capabilities,
  on_attach = custom_on_attach,
})
