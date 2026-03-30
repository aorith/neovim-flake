local xdg_config = vim.env.XDG_CONFIG_HOME ~= nil and vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. '/.config')

local function find_stylua_conf()
  local conf_paths = {
    vim.fn.getcwd() .. '/stylua.toml',
    vim.fn.getcwd() .. '/.stylua.toml',
    vim.env.XDG_CONFIG_HOME .. '/' .. Config.nvim_appname .. '/stylua.toml',
  }

  for _, v in ipairs(conf_paths) do
    if vim.fn.filereadable(v) == 1 then return { '--config-path', v } end
  end
  return {}
end

require('conform').setup({
  log_level = vim.log.levels.ERROR,
  notify_on_error = true,

  default_format_opts = {
    lsp_format = 'fallback',
    async = false,
    timeout_ms = 2500,
  },

  formatters_by_ft = {
    -- go install mvdan.cc/gofumpt@latest
    -- go install golang.org/x/tools/cmd/goimports@latest
    go = { 'goimports', 'gofumpt' },

    jinja = { 'djlint', lsp_format = 'fallback' },
    htmldjango = { 'djlint', lsp_format = 'fallback' },

    html = { 'prettierd' },
    css = { 'prettierd', lsp_format = 'prefer' },
    scss = { 'prettierd', lsp_format = 'prefer' },
    graphql = { 'prettierd', lsp_format = 'fallback' },
    javascript = { 'prettierd', lsp_format = 'prefer' },
    jsonc = { 'prettierd', lsp_format = 'fallback' },
    markdown = { 'prettierd', lsp_format = 'prefer' },
    typescript = { 'prettierd', lsp_format = 'prefer' },
    yaml = { 'prettierd', 'trim_newlines', lsp_format = 'fallback' }, -- yamlfmt/yamlfix/prettierd (yamlfmt breaks yaml blocks (key: |) sometimes)

    hurl = { 'hurlfmt' },
    json = { 'jq' },
    jsonnet = { 'jsonnetfmt' },
    lua = { 'stylua', lsp_format = 'fallback' },
    nix = { 'nixfmt' },
    python = { 'ruff_format', 'ruff_organize_imports', lsp_format = 'fallback' }, -- ruff_format & ruff_organize_imports  ||  black & isort
    sh = { 'shfmt' },
    templ = { 'templ', lsp_format = 'fallback' },
    toml = { 'taplo', lsp_format = 'fallback' },
  },

  formatters = {
    yamlfmt = { prepend_args = { '-conf', xdg_config .. '/' .. Config.nvim_appname .. '/extra/yamlfmt' } },
    shfmt = { prepend_args = { '--indent', '4' } },
    ruff = { prepend_args = { '--ignore', 'F841' } },
    stylua = { prepend_args = find_stylua_conf },

    -- Organize imports taking into account local package/module (see gopls config)
    goimports = { command = 'goimports', prepend_args = Config.gopls.goimports_args },
  },
})
