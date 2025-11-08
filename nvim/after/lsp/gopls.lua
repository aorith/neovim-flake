---@type vim.lsp.config

return {
  settings = {
    -- https://tip.golang.org/gopls/settings
    -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
    -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
    gopls = {
      gofumpt = true,
      usePlaceholders = false, -- annoying
    },
  },

  before_init = function(_, config)
    if vim.fn.executable('go') ~= 1 then return end

    local module = vim.fn.trim(vim.fn.system('go list -m'))
    if vim.v.shell_error ~= 0 then return end
    module = module:gsub('\n', ',')

    -- See conform config
    _G.Config.gopls.goimports_args = { '-local', module }
  end,
}
