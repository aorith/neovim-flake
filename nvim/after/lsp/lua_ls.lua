---@type vim.lsp.Config
return {
  on_init = function(client)
    client.server_capabilities.documentFormattingProvider = nil
    client.server_capabilities.documentRangeFormattingProvider = nil
  end,

  settings = {
    Lua = {
      addonManager = { enable = false },
      format = { enable = false },
      hint = { enable = true },
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
      telemetry = { enable = false },
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file("", true),
        -- Don't analyze code from submodules
        ignoreSubmodules = true,
      },
    },
  },
}
