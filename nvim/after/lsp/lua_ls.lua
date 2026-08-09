---@type vim.lsp.Config
return {
  on_init = function(client)
    client.server_capabilities.documentFormattingProvider = nil
    client.server_capabilities.documentRangeFormattingProvider = nil
  end,

  on_attach = function(client, buf_id)
    -- Reduce very long list of triggers for better 'mini.completion' experience
    client.server_capabilities.completionProvider.triggerCharacters = { '.', ':', '#', '(' }
  end,

  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = {
        library = { vim.env.VIMRUNTIME },
        -- ignoreSubmodules = true,
        checkThirdParty = false,
      },
      format = { enable = false },
      telemetry = { enable = false },
    },
  },
}
