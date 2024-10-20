local M = {}

M.setup = function()
  local miniclue = require("mini.clue")
  ---@diagnostic disable-next-line: redundant-parameter
  miniclue.setup({
    window = {
      delay = 350,

      config = {
        anchor = "SW",
        row = "auto",
        col = "auto",
        width = "auto",
        border = "single",
      },
    },

    triggers = {
      -- Leader triggers
      { mode = "n", keys = "<Leader>" },
      { mode = "x", keys = "<Leader>" },
      -- Local leader
      -- { mode = "n", keys = "<LocalLeader>" },
      -- { mode = "x", keys = "<LocalLeader>" },

      -- Built-in completionmini
      { mode = "i", keys = "<C-x>" },

      -- `g` key
      { mode = "n", keys = "g" },
      { mode = "x", keys = "g" },

      -- Marks
      { mode = "n", keys = "'" },
      { mode = "n", keys = "`" },
      { mode = "x", keys = "'" },
      { mode = "x", keys = "`" },

      -- Registers
      { mode = "n", keys = '"' },
      { mode = "x", keys = '"' },
      { mode = "i", keys = "<C-r>" },
      { mode = "c", keys = "<C-r>" },

      -- Window commands
      { mode = "n", keys = "<C-w>" },

      -- `z` key
      { mode = "n", keys = "z" },
      { mode = "x", keys = "z" },
    },

    clues = {
      { mode = "n", keys = "<leader>b", desc = "+buffers" },
      { mode = "n", keys = "<leader>f", desc = "+file/find" },
      { mode = "n", keys = "<leader>l", desc = "+lsp" },
      { mode = "n", keys = "<leader>t", desc = "+toggles" },
      { mode = "n", keys = "<leader>w", desc = "+windows" },
      { mode = "n", keys = "<leader>x", desc = "+diagnostics/quickfix" },
      { mode = "n", keys = "<leader>g", desc = "+git" },

      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
    },
  })
end

return M
