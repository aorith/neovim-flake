-- apply only if buffer is a file so it does not mess with documentation
if vim.fn.expand("%") == "" then return end

vim.bo.textwidth = 0

vim.wo[0][0].number = false
vim.wo[0][0].signcolumn = "auto"
vim.wo[0][0].spell = true
vim.wo[0][0].foldexpr = "nvim_treesitter#foldexpr()"
vim.wo[0][0].foldmethod = "expr"
vim.wo[0][0].foldlevel = 99
vim.wo[0][0].breakindent = true

vim.wo[0][0].conceallevel = 0
vim.wo[0][0].wrap = true

---@diagnostic disable-next-line: inject-field
vim.b.minihipatterns_config = {
  highlighters = {
    -- Highlight markdown 'tags'
    mdtags = { pattern = "%f[#]()#%w+", group = "Special" },
  },
}

-- Mappings
local utils = require("aorith.core.utils")

vim.keymap.set("n", "<TAB>", "]]", { remap = true, desc = "Next header " })
vim.keymap.set("n", "<S-TAB>", "[[", { remap = true, desc = "Previous header" })
vim.keymap.set("n", "<LocalLeader>c", utils.markdown_insert_codeblock, { desc = "Insert code block" })
vim.keymap.set("n", "tt", utils.markdown_todo_toggle, { desc = "Toggle checkbox" })
