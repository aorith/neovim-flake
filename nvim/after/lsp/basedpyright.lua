---@type vim.lsp.Config
-- https://docs.basedpyright.com/latest/configuration/language-server-settings/
return {
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        autoImportCompletions = true,
        useLibraryCodeForTypes = true,
        -- Override this using a pyproject.toml
        diagnosticMode = 'openFilesOnly',
        typeCheckingMode = 'standard',
      },
    },
  },
}
