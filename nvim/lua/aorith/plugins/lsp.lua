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
    source = "always",
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
  if client and client.server_capabilities.documentHighlightProvider then
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

-- LSP servers and clients are able to communicate to each other what features they support.
--  By default, Neovim doesn't support everything that is in the LSP Specification.
--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

-- Load LSP
require("neodev").setup() -- make sure to setup neodev BEFORE lspconfig
local lspconfig = require("lspconfig")

lspconfig.nil_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  -- settings = { ["nil"] = { formatting = { command = { "nixpkgs-fmt" } } } },
})

lspconfig.bashls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.gopls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.sqlls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.yamlls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = { yaml = { keyOrdering = false } },
})

lspconfig.terraformls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.marksman.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.lua_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
        path = vim.split(package.path, ";"),
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files and plugins
        library = { vim.env.VIMRUNTIME },
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
  capabilities = capabilities,
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
  capabilities = capabilities,
})

lspconfig.tsserver.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.html.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.cssls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})
