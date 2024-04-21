local lint = require("lint")

local vale = lint.linters.vale
local args = vale.args or {}
table.insert(args, 1, vim.env.VALE_DIR .. "/vale.ini")
table.insert(args, 1, "--config")
vale.args = args

lint.linters_by_ft = {
  go = { "golangcilint" },
  htmldjango = { "djlint" },
  jinja = { "djlint" },
  nix = { "nix" },
  --python = { "ruff" }, -- ruff already lints with ruff_lsp
  yaml = { "yamllint" },
  markdown = { "vale" },
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost", "BufWritePost", "TextChanged", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("Nvim-Lint", { clear = true }),
  callback = function(args)
    lint.try_lint()
    lint.try_lint("typos") -- run on all files
  end,
})
