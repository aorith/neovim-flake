local utils = require("core.utils")
local map = vim.keymap.set

-- Show active LSP clients
map("n", "<leader>la", function()
  utils.show_in_popup(utils.get_active_lsp_clients(), "markdown")
end, { desc = "Get active LSP clients" })

-- Misc
map("n", "x", '"_x', { desc = "Avoid 'x' copying to the register" })
map("v", "<leader>y", '"+y', { remap = true, desc = "Copy to the system clipboard" })
map("n", "<leader>y", '"+yy', { remap = true, desc = "Copy to the system clipboard" })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Get highlight group under cursor
map("n", "<C-e>", function()
  local result = vim.treesitter.get_captures_at_cursor(0)
  print(vim.inspect(result))
end, { desc = "highlight group under cursor" })

map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

-- highlights under cursor
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })

-- buffers
vim.keymap.set("n", "<leader><TAB>", "<cmd>bnext<CR>", { silent = true, desc = "Next buffer" })
vim.keymap.set("n", "<leader>b", function()
  local curbufnr = vim.api.nvim_get_current_buf()
  local bufinfo
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if bufnr ~= curbufnr and vim.api.nvim_buf_get_option(bufnr, "modified") == false then
      bufinfo = vim.fn.getbufinfo(bufnr)[1]
      if bufinfo.loaded == 1 and bufinfo.listed == 1 then
        vim.cmd("bd! " .. tostring(bufnr))
      end
    end
  end
end, { desc = "Close all other unmodified buffers" })

-- windows
map("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
map("n", "<leader>w-", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>w|", "<C-W>v", { desc = "Split window right" })
map("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right" })

-- ui
vim.keymap.set("n", "<leader>ub", function()
  if vim.o.background == "light" then
    vim.o.background = "dark"
  else
    vim.o.background = "light"
  end
end, { remap = true, desc = "Toggle dark/light mode" })

vim.keymap.set("n", "<leader>ud", function()
  if vim.diagnostic.is_disabled() then
    vim.diagnostic.enable()
  else
    vim.diagnostic.disable()
  end
  vim.notify("Diagnostics " .. (vim.diagnostic.is_disabled() and "OFF" or "ON"))
end, { remap = true, desc = "Toggle diagnostics" })

vim.keymap.set("n", "<leader>ul", function()
  if vim.opt.list._value then
    vim.opt.list = false
  else
    vim.opt.list = true
  end
  vim.notify("List chars: " .. (vim.opt.list._value and "ENABLED" or "DISABLED"))
end, { remap = true, desc = "Toggle list chars" })

-- undotree
vim.keymap.set("n", "<leader>U", "<cmd>UndotreeToggle<cr>", { desc = "Undotree" })

-- others
vim.keymap.set("", "<F1>", "<nop>") -- "" == map
vim.keymap.set("!", "<F1>", "<nop>") -- "!" == map!
vim.api.nvim_create_user_command("W", "w", { bang = true })
vim.api.nvim_create_user_command("Q", "q", { bang = true })

--- LSP
-- having the keymaps outside of the 'on_attach' lsp allows to use them even if
-- no lsp server is attached, useful for null-ls and I prefer the keymap to fail than to not exist

-- format
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
vim.keymap.set("n", "<leader>lf", format, { desc = "Format Document" })
vim.keymap.set("v", "<leader>lf", format, { desc = "Format Range" })

-- diagnostics
vim.keymap.set("n", "<leader>ll", vim.diagnostic.open_float, { desc = "[L]ine diagnostics" })
vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist, { desc = "Set Loc List" })
vim.keymap.set("n", "<leader>lj", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>lk", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })

vim.keymap.set("n", "<leader>lc", vim.lsp.buf.code_action, { desc = "Code actions" })
vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, { desc = "[H]over" })
vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "[R]ename" })
vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, { desc = "[S]ignature" })

-- without leader key
vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", { desc = "[G]oto [D]efinition" })
vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", { desc = "[G]oto [R]eferences" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "[G]oto [D]eclaration" })
vim.keymap.set("n", "gI", "<cmd>Telescope lsp_implementations<cr>", { desc = "[G]oto [I]mplementation" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
