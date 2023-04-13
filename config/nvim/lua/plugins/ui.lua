--[[
require("indent_blankline").setup({
  filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "noice" },
  use_treesitter = true,
  show_first_indent_level = false,
})
--]]

require("notify").setup({
  max_width = 80,
  minimum_width = 20,
  stages = "static",
  render = "minimal",
})

require("noice").setup({
  cmdline = {},

  lsp = {
    override = {
      ["cmp.entry.get_documentation"] = true,
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
    },
    progress = {
      enabled = true,
    },
    signature = {
      enabled = false,
    },
  },

  popupmenu = {
    backend = "cmp",
  },

  routes = {
    {
      -- shell commands to output
      filter = { cmdline = "^:!" },
      view = "popup",
    },
    {
      -- lua commands to output
      filter = { cmdline = "^:lua" },
      view = "popup",
    },
    {
      -- opens long messages in a split
      filter = {
        event = "msg_show",
        min_height = 4,
      },
      view = "cmdline_output",
    },
    {
      -- ignore code actions spam
      filter = {
        event = "notify",
        find = "No code actions available",
      },
      opts = { skip = true },
    },
    -- ignore search count
    {
      filter = {
        event = "msg_show",
        kind = "search_count",
      },
      opts = { skip = true },
    },
  },

  views = {
    cmdline_popup = {
      border = {
        style = "single",
      },
    },
    confirm = {
      border = {
        style = "single",
        text = { top = "" },
      },
    },
  },
})

-- stylua: ignore start
vim.keymap.set("c", "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, { desc = "Redirect Cmdline" })
vim.keymap.set("n", "<leader>nl", function() require("noice").cmd("last") end, { desc = "Noice Last Message" })
vim.keymap.set("n", "<leader>nh", function() require("noice").cmd("history") end, { desc = "Noice History" })
vim.keymap.set("n", "<leader>na", function() require("noice").cmd("all") end, { desc = "Noice All" })
-- stylua: ignore end
