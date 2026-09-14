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
        -- Every 'lua/' directory in 'runtimepath', so plugin APIs resolve instead of showing up as undefined.
        -- Excludes 'config' dir to avoid double counting it.
        library = vim.tbl_filter(
          function(path) return vim.uv.fs_realpath(path) ~= vim.uv.fs_realpath(vim.fn.stdpath('config') .. '/lua') end,
          vim.api.nvim_get_runtime_file('lua', true)
        ),
        -- ignoreSubmodules = true,
        checkThirdParty = false,
      },
      format = { enable = false },
      telemetry = { enable = false },
    },
  },
}
