---@diagnostic disable: missing-fields

require("nvim-dap-virtual-text").setup({
  enabled = true,
  enabled_commands = false,
  highlight_changed_variables = true,
  all_references = false,
  all_frames = false,
})

local dm = require("debugmaster")
-- make sure you don't have any other keymaps that starts with "<leader>d" to avoid delay
-- Alternative keybindings to "<leader>d" could be: "<leader>m", "<leader>;"
vim.keymap.set({ "n", "v" }, "<leader>d", dm.mode.toggle, { desc = "Toggle DEBUG MODE", nowait = true })
-- If you want to disable debug mode in addition to leader+d using the Escape key:
-- vim.keymap.set("n", "<Esc>", dm.mode.disable)
-- This might be unwanted if you already use Esc for ":noh"
vim.keymap.set("t", "<C-\\>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
dm.plugins.osv_integration.enabled = true -- needed if you want to debug neovim lua code

vim.api.nvim_create_autocmd("User", {
  pattern = "DebugModeChanged",
  callback = function(args) Config.debug_mode = args.data.enabled end,
})

local dap = require("dap")

require("dap-python").setup("uv")
table.insert(dap.configurations.python, {
  type = "python",
  request = "launch",
  name = "Uvicorn module",
  module = "uvicorn",
  args = function()
    return {
      vim.fn.input("App module > ", "main:app", "file"),
      -- '--reload', -- doesn't work
      "--use-colors",
    }
  end,
  pythonPath = "python",
  console = "integratedTerminal",
})
