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

  -- disable hover in favor of pyright
  if client.name == "ruff_lsp" then client.server_capabilities.hoverProvider = false end

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

lspconfig.yamlls.setup({
  on_attach = on_attach,
  settings = { yaml = { keyOrdering = false } },
})

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

lspconfig.pyright.setup({
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

lspconfig.ruff_lsp.setup({
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
