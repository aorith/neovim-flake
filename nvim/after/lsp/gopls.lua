---@type vim.lsp.config

return {
  settings = {
    -- https://tip.golang.org/gopls/settings
    -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
    -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
    gopls = {
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      codelenses = {
        gc_details = false,
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      experimentalPostfixCompletions = true,
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      gofumpt = true,
      semanticTokens = true,
      staticcheck = true,
      usePlaceholders = true,
    },
  },
}
