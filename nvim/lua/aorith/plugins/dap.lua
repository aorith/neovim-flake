---@diagnostic disable: missing-fields

require("dap-view").setup({
  windows = {
    terminal = {
      hide = { "go" }, -- adapter names
    },
  },
})

require("dap-python").setup("uv")

require("nvim-dap-virtual-text").setup({
  enabled = true,
  enabled_commands = false,
  highlight_changed_variables = true,
  all_references = false,
  all_frames = false,
})

local dap, dv = require("dap"), require("dap-view")

dap.listeners.before.attach["dap-view-config"] = function() dv.open() end
dap.listeners.before.launch["dap-view-config"] = function() dv.open() end
dap.listeners.before.event_terminated["dap-view-config"] = function() dv.close() end
dap.listeners.before.event_exited["dap-view-config"] = function() dv.close() end

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
