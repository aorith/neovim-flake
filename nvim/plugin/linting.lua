local lint = require("lint")
local linters = require("lint").linters

lint.linters_by_ft = {
  go = { "golangcilint" },
  htmldjango = { "djlint" },
  jinja = { "djlint" },
  markdown = { "vale", "proselint" },
  nix = { "nix" },
  --python = { "ruff" }, -- ruff already lints with ruff_lsp
  yaml = { "yamllint" },
}

linters.vale.args = {
  "--output=JSON",
  "--ext=.md",
  "--no-exit",
  "--config=" .. vim.fn.getenv("HOME") .. "/.config/vale/vale.ini",
}

-- Add typos to the above fts
for ft, _ in pairs(lint.linters_by_ft) do
  table.insert(lint.linters_by_ft[ft], "typos")
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost", "BufWritePost", "TextChanged", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("Nvim-Lint", { clear = true }),
  callback = function(args)
    -- Ignore 3rd party code.
    if args.file:match("/(node_modules|__pypackages__|site_packages)/") then return end

    lint.try_lint()
  end,
})
