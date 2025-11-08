local utils = require('aorith.core.utils')

local opts = {
  log_level = vim.log.levels.ERROR,
  notify_on_error = true,

  formatters_by_ft = {
    jinja = { 'djlint', lsp_format = 'fallback' },
    htmldjango = { 'djlint', lsp_format = 'fallback' },

    css = { 'prettierd', lsp_format = 'prefer' },
    scss = { 'prettierd', lsp_format = 'prefer' },
    graphql = { 'prettierd', lsp_format = 'fallback' },
    javascript = { 'prettierd', lsp_format = 'prefer' },
    javascriptreact = { 'prettierd', lsp_format = 'prefer' },
    json = { 'prettierd', lsp_format = 'fallback' },
    jsonc = { 'prettierd', lsp_format = 'fallback' },
    markdown = { 'prettierd', lsp_format = 'prefer' },
    typescript = { 'prettierd', lsp_format = 'prefer' },
    typescriptreact = { 'prettierd', lsp_format = 'prefer' },

    lua = { 'stylua', lsp_format = 'fallback' },
    nix = { 'nixfmt' },
    python = { 'ruff_format', 'ruff_organize_imports', lsp_format = 'first' }, -- ruff_format & ruff_organize_imports  ||  black & isort
    toml = { 'taplo', lsp_format = 'fallback' },
    yaml = { 'prettierd', 'trim_newlines', lsp_format = 'fallback' }, -- yamlfmt/yamlfix/prettierd (yamlfmt breaks yaml blocks (key: |) sometimes)

    sh = { 'shfmt' },
    bash = { 'shfmt' },

    templ = { 'templ', lsp_format = 'fallback' },

    jsonnet = { 'jsonnetfmt' },

    hurl = { 'hurlfmt' },
  },
}

local xdg_config = vim.env.XDG_CONFIG_HOME ~= nil and vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. '/.config')
require('conform').formatters.yamlfmt = {
  prepend_args = { '-conf', xdg_config .. '/' .. Config.nvim_appname .. '/extra/yamlfmt' },
}
require('conform').formatters.shfmt = { prepend_args = { '--indent', '4' } }
require('conform').formatters.ruff = { prepend_args = { '--ignore', 'F841' } }
require('conform').formatters.stylua = { prepend_args = utils.find_stylua_conf }

require('conform').setup(opts)
