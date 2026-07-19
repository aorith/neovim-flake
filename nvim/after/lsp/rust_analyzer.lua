---@type vim.lsp.Config
-- https://rust-analyzer.github.io/book/configuration.html
return {
  settings = {
    ['rust-analyzer'] = {
      check = {
        command = 'clippy',
      },
    },
  },
}
