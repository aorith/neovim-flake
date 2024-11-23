local lsp = vim.lsp

-- Log level
lsp.set_log_level(vim.log.levels.OFF)

-- Diagnostics
vim.diagnostic.config({
  signs = { priority = 9999 },
  underline = true,
  update_in_insert = false, -- false so diags are updated on InsertLeave
  virtual_text = { severity = { min = "ERROR" } },
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = true,
    header = "",
  },
})

-- common handlers
lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, { border = "rounded" })
lsp.handlers["textDocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, { border = "rounded" })

local on_attach = function(client, bufnr)
  -- disable some more capabilities
  if client.name == "pylsp" then
    client.server_capabilities.renameProvider = false
    client.server_capabilities.rename = false
  end

  -- When you move your cursor, the highlights will be cleared (the second autocommand).
  if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end

  -- notify attachment
  ---@diagnostic disable-next-line: param-type-mismatch
  vim.notify(client.name .. " started", vim.log.levels.INFO, {
    -- title = "Attaching LSP",
    timeout = 3000,
  })
end

-- Load LSP
local lspconfig = require("lspconfig")

lspconfig.nil_ls.setup({
  on_attach = on_attach,
  -- settings = { ["nil"] = { formatting = { command = { "nixpkgs-fmt" } } } },
})

lspconfig.bashls.setup({
  on_attach = on_attach,
})

lspconfig.gopls.setup({
  on_attach = on_attach,
})

lspconfig.sqlls.setup({
  on_attach = on_attach,
})

lspconfig.yamlls.setup(require("yaml-companion").setup({
  -- Extra schemas
  schemas = {
    {
      name = "Kubernetes 1.22.4",
      uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.22.4-standalone-strict/all.json",
    },
  },

  -- Additional options that will be merged in the final LSP config
  lspconfig = {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    settings = {
      redhat = { telemetry = { enabled = false } },
      yaml = {
        validate = true,
        format = { enable = true },
        keyOrdering = false,
        hover = true,
        schemaStore = {
          enable = true,
          url = "https://www.schemastore.org/api/json/catalog.json",
        },
        schemaDownload = { enable = true },
        schemas = {},
        trace = { server = "debug" },
      },
    },
  },
}))

lspconfig.terraformls.setup({
  on_attach = on_attach,
})

lspconfig.marksman.setup({
  on_attach = on_attach,
})

lspconfig.lua_ls.setup({
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

lspconfig.basedpyright.setup({
  on_attach = on_attach,
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

lspconfig.ruff.setup({
  on_attach = on_attach,
})

lspconfig.ts_ls.setup({
  on_attach = on_attach,
})

lspconfig.html.setup({
  on_attach = on_attach,
})

lspconfig.cssls.setup({
  on_attach = on_attach,
})

lspconfig.templ.setup({
  on_attach = on_attach,
})
