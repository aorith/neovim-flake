local miniclue = require("mini.clue")
---@diagnostic disable-next-line: redundant-parameter
miniclue.setup({
  window = { delay = 200, config = { width = "auto" } },

  triggers = {
    { mode = "n", keys = "<Leader>" }, -- Leader triggers
    { mode = "x", keys = "<Leader>" },
    { mode = "n", keys = "<LocalLeader>" },
    { mode = "x", keys = "<LocalLeader>" },
    { mode = "n", keys = "\\" }, -- mini.basics
    { mode = "n", keys = "[" }, -- mini.bracketed
    { mode = "n", keys = "]" },
    { mode = "x", keys = "[" },
    { mode = "x", keys = "]" },
    { mode = "i", keys = "<C-x>" }, -- Built-in completion
    { mode = "n", keys = "g" }, -- `g` key
    { mode = "x", keys = "g" },
    { mode = "n", keys = "'" }, -- Marks
    { mode = "n", keys = "`" },
    { mode = "x", keys = "'" },
    { mode = "x", keys = "`" },
    { mode = "n", keys = '"' }, -- Registers
    { mode = "x", keys = '"' },
    { mode = "i", keys = "<C-r>" },
    { mode = "c", keys = "<C-r>" },
    { mode = "n", keys = "<C-w>" }, -- Window commands
    { mode = "n", keys = "z" }, -- `z` key
    { mode = "x", keys = "z" },
  },

  clues = {
    { mode = "n", keys = "<leader>b", desc = "+Buffer" },
    { mode = "n", keys = "<leader>f", desc = "+Find" },
    { mode = "n", keys = "<leader>g", desc = "+Git" },
    { mode = "x", keys = "<leader>g", desc = "+Git" },
    { mode = "n", keys = "<leader>l", desc = "+LSP" },
    { mode = "n", keys = "<leader>w", desc = "+Window" },
    { mode = "n", keys = "<leader>x", desc = "+Quickfix" },
    { mode = "n", keys = "<leader>t", desc = "+Toggle" },
    { mode = "n", keys = "<Leader>v", desc = "+Visits" },
    { mode = "n", keys = "<Leader>n", desc = "+Notes" },

    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  },
})
