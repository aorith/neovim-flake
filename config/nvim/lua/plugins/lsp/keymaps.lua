local utils = require("core.utils")

local M = {}

function M.set_keymaps(bufnr)
  local map = function(mode, map, cmd, desc)
    local bufopts = { noremap = true, silent = true, buffer = bufnr, desc = desc }
    vim.keymap.set(mode, map, cmd, bufopts)
  end
  local format = function()
    vim.lsp.buf.format({
      async = false,
      timeout_ms = 3000,

      -- excluded clients
      filter = function(client)
        if client.name == "sumneko_lua" or client.name == "lua_ls" or client.name == "nil_ls" then
          return false
        end
        if client.name == "bashls" then
          return false
        end
        if client.name == "pyright" then
          return false
        end

        return true
      end,
    })
  end

  map("n", "<leader>lf", format, "Format Document")
  map("v", "<leader>lf", format, "Format Range")

  map("n", "<leader>lc", vim.lsp.buf.code_action, "Code actions")

  map("n", "<leader>lh", vim.lsp.buf.hover, "[H]over")
  map("n", "<leader>ll", vim.diagnostic.open_float, "[L]ine diagnostics")
  map("n", "<leader>lq", vim.diagnostic.setloclist, "Set Loc List")
  map("n", "<leader>lj", vim.diagnostic.goto_next, "Next diagnostic")
  map("n", "<leader>lk", vim.diagnostic.goto_prev, "Prev diagnostic")
  map("n", "<leader>lr", vim.lsp.buf.rename, "[R]ename")
  map("n", "<leader>ls", vim.lsp.buf.signature_help, "[S]ignature")

  -- without leader
  map("n", "gd", "<cmd>Telescope lsp_definitions<cr>", "[G]oto [D]efinition")
  map("n", "gr", "<cmd>Telescope lsp_references<cr>", "[G]oto [R]eferences")
  map("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  map("n", "gI", "<cmd>Telescope lsp_implementations<cr>", "[G]oto [I]mplementation")
  map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
end

return M
