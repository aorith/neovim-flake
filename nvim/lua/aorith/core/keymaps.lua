local utils = require("aorith.core.utils")

-- Copy to primary selection on select
map("v", "<LeftRelease>", '"*ygv')

-- Misc
map("n", "x", '"_x', { desc = "Avoid 'x' copying to the register" })
map("v", "<leader>y", '"+y', { remap = true, desc = "Copy to the system clipboard" })
map("n", "<leader>y", '"+yy', { remap = true, desc = "Copy to the system clipboard" })

-- Moves lines
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Navigate wrapped lines
map("n", "j", "gj")
map("n", "k", "gk")

-- Center view on search
map("n", "n", "nzz")
map("n", "N", "Nzz")

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

-- Don't reset indent on '#', see :h smartindent
map("i", "#", "X#")

-- Get highlight group under cursor
map("n", "<C-e>", function()
  local result = vim.treesitter.get_captures_at_cursor(0)
  print(vim.inspect(result))
end, { desc = "highlight group under cursor" })

map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

-- highlights under cursor
map("n", "<leader>tI", vim.show_pos, { desc = "Inspect Pos" })

-- buffers
map("n", "<leader><TAB>", "<cmd>bnext<CR>", { silent = true, desc = "Next buffer" })
--map("n", "<TAB>", "<cmd>bnext<CR>", { silent = true, desc = "Next buffer" })
--map("n", "<S-TAB>", "<cmd>bprevious<CR>", { silent = true, desc = "Previous buffer" })
--map("n", "<leader><TAB>", "<cmd>b#<CR>", { silent = true, desc = "Last buffer" })

map("n", "<leader>bb", function()
  local curbufnr = vim.api.nvim_get_current_buf()
  local bufinfo
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if bufnr ~= curbufnr and vim.api.nvim_get_option_value("modified", { buf = bufnr }) == false then
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
map("n", "<leader>tb", function()
  if vim.o.background == "light" then
    vim.opt.background = "dark"
  else
    vim.opt.background = "light"
  end
end, { remap = true, desc = "Toggle dark/light mode" })

-- Spelling
map("n", "<leader>ts", function()
  vim.opt_local.spell = not (vim.opt.spell:get())
  vim.opt_local.spelllang = "en_us,es"
  vim.notify("Spell " .. (vim.opt.spell:get() and "ON" or "OFF"))
end, { desc = "toggle spelling" })

-- toggle mini.indentscope
map("n", "<leader>ti", function()
  vim.g.miniindentscope_disable = not vim.g.miniindentscope_disable
  vim.notify("Indentscope " .. (vim.g.miniindentscope_disable and "OFF" or "ON"))
end, { desc = "toggle indentscope" })

-- toggle diagnostics
map("n", "<leader>td", function()
  if vim.diagnostic.is_enabled() then
    vim.diagnostic.enable(false)
  else
    vim.diagnostic.enable(true)
  end
  vim.notify("Diagnostics " .. (vim.diagnostic.is_enabled() and "OFF" or "ON"))
end, { remap = true, desc = "Toggle diagnostics" })

-- toggle listchars
map("n", "<leader>tl", function() vim.cmd("set list! list?") end, { remap = true, desc = "Toggle list chars" })

-- others
map("", "<F1>", "<nop>") -- "" == map
map("!", "<F1>", "<nop>") -- "!" == map!
vim.api.nvim_create_user_command("W", "w", { bang = true })
vim.api.nvim_create_user_command("Q", "q", { bang = true })

-- terminal
map({ "n", "v", "i" }, "<F1>", "<cmd>split | term<cr>", { desc = "Open terminal" })
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Go to normal mode" })

--- LSP
-- having the keymaps outside of the 'on_attach' lsp allows to use them even if
-- no lsp server is attached, useful for null-ls and I prefer the keymap to fail than to not exist

-- Show active LSP clients
map(
  "n",
  "<leader>la",
  function() utils.show_in_popup(utils.get_active_lsp_clients(), "markdown") end,
  { desc = "Get active LSP clients" }
)

-- quick fix
map("n", "<leader>j", "<cmd>cnext<CR>", { desc = "Next item in QuickFix" })
map("n", "<leader>k", "<cmd>cprevious<CR>", { desc = "Previous item in QuickFix" })

-- diagnostics
map("n", "<leader>ll", vim.diagnostic.open_float, { desc = "[L]ine diagnostics" })
map("n", "<leader>lq", vim.diagnostic.setloclist, { desc = "Set Loc List" })
map("n", "<leader>lj", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>lk", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })

map("n", "<leader>lc", vim.lsp.buf.code_action, { desc = "Code actions" })
map("n", "<leader>lh", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }))
  vim.notify("Inlay Hints " .. (vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }) and "ON" or "OFF"))
end, { desc = "Toggle inlay [h]ints" })
map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "[R]ename" })
map("n", "<leader>ls", vim.lsp.buf.signature_help, { desc = "[S]ignature" })

-- UndoTree
map("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "UndoTree" })

-- without leader key
map("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })

-- Diffview
map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "DiffviewOpen" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory<cr>", { desc = "DiffviewFileHistory" })
