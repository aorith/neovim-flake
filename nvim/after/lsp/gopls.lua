---@type vim.lsp.config

return {
  settings = {
    -- https://tip.golang.org/gopls/settings
    -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
    -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
    gopls = {
      -- go install mvdan.cc/gofumpt@latest
      -- go install golang.org/x/tools/cmd/goimports@latest
      gofumpt = true,
      usePlaceholders = false, -- annoying
    },
  },
}
