---@type vim.lsp.Config
return {
  on_init = function(client) client.capabilities.textDocument.completion.completionItem.snippetSupport = true end,

  settings = {
    html = {
      format = {
        templating = true,
        wrapLineLength = 120,
        wrapAttributes = 'auto',
      },
      hover = {
        documentation = true,
        references = true,
      },
    },
  },
}
