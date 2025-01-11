local lint = require("lint")

lint.linters_by_ft = {
  --python = { "ruff" }, -- ruff already lints with ruff lsp
  ansible = { "ansible_lint" },
  go = { "golangcilint" },
  htmldjango = { "djlint" },
  jinja = { "djlint" },
  nix = { "nix" },
  terraform = { "tflint" },
  hcl = { "tflint" },
  yaml = { "yamllint" },
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost", "BufWritePost", "TextChanged", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("Nvim-Lint", { clear = true }),
  callback = function()
    lint.try_lint()
    if vim.bo.filetype ~= "bigfile" then
      lint.try_lint("typos") -- run on all files
    end
  end,
})
