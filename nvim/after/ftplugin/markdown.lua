vim.opt_local.colorcolumn = "0"
vim.opt_local.conceallevel = 1
vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldlevel = 99
vim.opt_local.textwidth = 0
vim.opt_local.wrap = true
vim.opt_local.linebreak = true

-- Mappings
local utils = require("aorith.core.utils")
map("n", "<TAB>", utils.markdown_next_link, { buffer = 0, desc = "Next header or link" })
map("n", "<S-TAB>", utils.markdown_prev_link, { buffer = 0, desc = "Prev header or link" })
map("n", "<LocalLeader>c", utils.markdown_insert_codeblock, { buffer = 0, desc = "Insert code block" })
map("n", "tt", utils.markdown_todo_toggle, { buffer = 0, desc = "Toggle To-Do" })
map("n", "<CR>", vim.lsp.buf.definition, { buffer = 0, desc = "Follow link (go to definition)" })

local mark_markdown_codeblock = function(_, match, _)
  local mask = string.rep("─", (85 - vim.fn.strchars(match)))
  return {
    virt_text = { { mask, "Comment" } },
    virt_text_pos = "eol",
    priority = 200,
    right_gravity = false,
  }
end

---@diagnostic disable-next-line: inject-field
vim.b.minihipatterns_config = {
  highlighters = {
    -- Highlight markdown 'tags'
    mdtags = { pattern = "%f[#]()#%w+", group = "Special" },
    -- Highlight markdown code blocks
    codeblock = { pattern = "%f[%w`]()```%w*", group = "", extmark_opts = mark_markdown_codeblock },
  },
}
