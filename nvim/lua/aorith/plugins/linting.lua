local lint = require("lint")

lint.linters_by_ft = {
  go = { "golangcilint" },
  htmldjango = { "djlint" },
  jinja = { "djlint" },
  nix = { "nix" },
  --python = { "ruff" }, -- ruff already lints with ruff_lsp
  yaml = { "yamllint" },
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost", "BufWritePost", "TextChanged", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("Nvim-Lint", { clear = true }),
  callback = function(args)
    lint.try_lint()
    lint.try_lint("typos") -- run on all files
  end,
})
