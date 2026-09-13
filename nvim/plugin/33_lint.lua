local lint = require('lint')

lint.linters_by_ft = {
  python = { 'ruff' },
  ansible = { 'ansible_lint' },
  go = { 'golangcilint' },
  htmldjango = { 'djlint' },
  jinja = { 'djlint' },
  nix = { 'nix' },
  terraform = { 'tflint' },
  hcl = { 'tflint' },
  yaml = { 'yamllint' },
  cue = { 'cue' },
}

-- F841: local variable assigned but never used. Insert before the trailing '-'
-- (stdin marker), which must stay the last argument.
local ruff_args = lint.linters.ruff.args
table.insert(ruff_args, #ruff_args, '--ignore')
table.insert(ruff_args, #ruff_args, 'F841')

-- 'InsertLeave' is deliberately absent: linters like golangci-lint scan the
-- whole package and are far too slow to run on every Insert mode exit.
NewAutocmd('lint', nil, { 'BufReadPost', 'BufWritePost' }, nil, function()
  if vim.bo.filetype ~= 'bigfile' then
    lint.try_lint()
    --   lint.try_lint('typos') -- run typos on all file types
  end
end, 'Lint')
