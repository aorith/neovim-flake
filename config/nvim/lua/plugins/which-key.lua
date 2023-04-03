local wk = require("which-key")
wk.setup({ plugins = { spelling = true } })

local keymaps = {
  mode = { "n", "v" },
  ["g"] = { name = "+goto" },
  ["gz"] = { name = "+surround" },
  ["]"] = { name = "+next" },
  ["["] = { name = "+prev" },
  ["<leader>b"] = { name = "+buffer" },
  ["<leader>c"] = { name = "+code" },
  ["<leader>f"] = { name = "+file/find" },
  ["<leader>g"] = { name = "+git" },
  ["<leader>gh"] = { name = "+hunks" },
  ["<leader>l"] = { name = "+lsp" },
  ["<leader>n"] = { name = "+notifications" },
  ["<leader>s"] = { name = "+search" },
  ["<leader>se"] = { name = "+extras" },
  ["<leader>u"] = { name = "+ui" },
  ["<leader>w"] = { name = "+windows" },
  ["<leader>x"] = { name = "+diagnostics/quickfix" },
}
wk.register(keymaps)
