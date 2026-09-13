---@type vim.lsp.Config
return {
  on_init = function(client)
    client.server_capabilities.documentFormattingProvider = nil
    client.server_capabilities.documentRangeFormattingProvider = nil
  end,

  on_attach = function(client)
    -- Reduce very long list of triggers for better 'mini.completion' experience
    local completion = client.server_capabilities.completionProvider
    if completion then completion.triggerCharacters = { '.', ':', '#', '(' } end
  end,

  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = {
        -- Every 'lua/' directory in 'runtimepath', so plugin APIs resolve instead of showing up as undefined
        library = vim.api.nvim_get_runtime_file('lua', true),
        -- ignoreSubmodules = true,
        checkThirdParty = false,
      },
      format = { enable = false },
      telemetry = { enable = false },
    },
  },
}
