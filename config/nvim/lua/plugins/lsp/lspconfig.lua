-- Log level
vim.lsp.set_log_level("ERROR")

-- On attach
local on_attach = function(client, bufnr)
  vim.cmd("command! CheckLspServerCapabilities :lua =require('core.utils').custom_server_capabilities()")

  if client.server_capabilities.documentSymbolProvider then
    require("nvim-navic").attach(client, bufnr)
  end

  -- disable formatting to null-ls takes care
  if client.name == "sumneko_lua" or client.name == "lua_ls" or client.name == "nil_ls" then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    client.server_capabilities.formatting = false
    client.server_capabilities.formatRange = false
  end

  -- disable some more capabilities
  if client.name == "pylsp" then
    client.server_capabilities.renameProvider = false
    client.server_capabilities.rename = false
  end

  -- disable hover in favor of pyright
  if client.name == "ruff_lsp" then
    client.server_capabilities.hoverProvider = false
    client.server_capabilities.hover = false
  end

  require("plugins.lsp.keymaps").set_keymaps(bufnr)
end

-- Diagnostics
vim.diagnostic.config({
  signs = true,
  underline = true,
  update_in_insert = false,
  --virtual_text = { spacing = 4, prefix = "●" },
  virtual_text = false,
  severity_sort = true,
  float = {
    focusable = false,
    format = function(diagnostic)
      -- custom format message
      if diagnostic == nil then
        return "No diagnostics."
      end
      local code = ""
      if diagnostic.code ~= nil then
        code = diagnostic.code
      elseif diagnostic.user_data ~= nil then
        code = (diagnostic.user_data.lsp or { code = "" }).code or ""
      end
      return string.format("%s [%s]", diagnostic.message, code)
    end,
    border = "rounded",
    source = "always",
    header = "Diagnostics:",
    prefix = " ",
  },
})

-- List of servers and their configs
local servers = require("plugins.lsp.servers")
local server_names = vim.tbl_keys(servers)
local ensure_installed = {}
for _, k in pairs(server_names) do
  if servers[k].ensure_installed_name then
    table.insert(ensure_installed, servers[k].ensure_installed_name)
  else
    -- skip some
    if k ~= "nil_ls" then
      table.insert(ensure_installed, k)
    end
  end
end

local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
}
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- actual function that setups the servers
local function setup(server)
  local server_config = {}
  if servers[server] ~= nil and servers[server].config ~= nil then
    server_config = servers[server].config
  end
  local server_enabled = true
  if servers[server] ~= nil then
    if servers[server].enabled ~= nil and not servers[server].enabled then
      server_enabled = false
    end
  end

  local server_opts = vim.tbl_deep_extend("force", {
    handlers = handlers,
    on_attach = on_attach,
    capabilities = vim.deepcopy(capabilities),
  }, server_config)

  if server_enabled then
    require("lspconfig")[server].setup(server_opts)
  end
end

for _, server in pairs(server_names) do
  setup(server)
end
