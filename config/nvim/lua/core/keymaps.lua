local get_active_lsp_clients = function()
  local servers = "Active LSP servers\n---\n\n"
  for _, c in pairs(vim.lsp.get_active_clients()) do
    servers = servers .. "\n*   " .. c.name
  end
  return servers
end

local map = vim.keymap.set

-- Show active LSP clients
map("n", "<leader>la", function()
  require("core.utils").show_in_popup(get_active_lsp_clients(), "markdown")
end, { desc = "Get active LSP clients" })

-- Misc
map("n", "x", '"_x', { desc = "Avoid 'x' copying to the register" })
map("v", "<leader>y", '"+y', { remap = true, desc = "Copy to the system clipboard"})
map("n", "<leader>y", '"+yy', { remap = true, desc = "Copy to the system clipboard"})

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
if vim.fn.has("nvim-0.9.0") == 1 then
  map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
end

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

-- TODO: vim.diagnostic.is_disabled is available in 0.9
local diag_enabled = true
vim.keymap.set("n", "<leader>ud", function()
  if diag_enabled then
    vim.diagnostic.disable()
    diag_enabled = not diag_enabled
  else
    vim.diagnostic.enable()
    diag_enabled = not diag_enabled
  end
  vim.notify("Diagnostics: " .. (diag_enabled and "ENABLED" or "DISABLED"))
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
