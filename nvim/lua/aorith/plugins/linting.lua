local lint = require("lint")
local vale = lint.linters.vale

if vim.fn.filereadable(vim.fn.getcwd() .. "/.vale.ini") == 0 then
  local args = vale.args or {}
  local vale_dir = vim.env.VALE_DIR ~= vim.NIL and vim.env.VALE_DIR or "/home/aorith/.config/vale"
  table.insert(args, 1, vale_dir .. "/vale.ini")
  table.insert(args, 1, "--config")
  vale.args = args
end

lint.linters_by_ft = {
  ansible = { "ansible_lint" },
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
  callback = function()
    lint.try_lint()
    if vim.bo.filetype ~= "bigfile" then
      lint.try_lint("typos") -- run on all files
    end
  end,
})
