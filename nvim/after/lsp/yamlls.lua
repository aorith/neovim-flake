-- https://github.com/redhat-developer/yaml-language-server

---@type vim.lsp.Config
return {
  on_init = function(client)
    client.server_capabilities.documentFormattingProvider = nil
    client.server_capabilities.documentRangeFormattingProvider = nil
  end,

  settings = {
    redhat = { telemetry = { enabled = false } },

    yaml = {
      validate = true,
      format = { enable = false },
      keyOrdering = false,
      hover = true,
      completion = true,

      schemaStore = {
        enable = true,
        url = 'https://www.schemastore.org/api/json/catalog.json',
      },
    },
  },
}
