vim.opt_local.colorcolumn = "0"
vim.opt_local.conceallevel = 1
vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldlevel = 99
vim.opt_local.wrap = true
vim.opt_local.textwidth = 80
vim.opt_local.linebreak = true

-- Mappings
local utils = require("aorith.core.utils")
map("n", "<TAB>", utils.markdown_next_link, { buffer = 0, desc = "Next header or link" })
map("n", "<S-TAB>", utils.markdown_prev_link, { buffer = 0, desc = "Prev header or link" })
map("n", "<LocalLeader>c", utils.markdown_insert_codeblock, { buffer = 0, desc = "Insert code block" })
map("n", "tt", utils.markdown_todo_toggle, { buffer = 0, desc = "Toggle To-Do" })
map("n", "<CR>", vim.lsp.buf.definition, { buffer = 0, desc = "Follow link (go to definition)" })

-- Switch to the current directory of the file if it's a note
-- local A = vim.api
-- local my_au = A.nvim_create_augroup("AORITH_MD", { clear = true })
-- A.nvim_create_autocmd("BufWinEnter", {
--   group = my_au,
--   pattern = "*.md",
--   callback = function()
--     if string.find(vim.api.nvim_buf_get_name(0), "/SYNC_STUFF/") then vim.cmd("cd %:p:h") end
--   end,
-- })

-- Highlight markdown 'tags'
---@diagnostic disable-next-line: inject-field
vim.b.minihipatterns_config = {
  highlighters = {
    mdtags = { pattern = "()#%w+()", group = "Special" },
  },
}
