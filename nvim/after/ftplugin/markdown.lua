vim.opt_local.colorcolumn = "0"
vim.opt_local.conceallevel = 0
vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldlevel = 99
vim.opt_local.textwidth = 0
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.spell = true

-- Mappings
local utils = require("aorith.core.utils")
map("n", "<TAB>", utils.markdown_next_link, { buffer = 0, desc = "Next header or link" })
map("n", "<S-TAB>", utils.markdown_prev_link, { buffer = 0, desc = "Prev header or link" })
map("n", "<LocalLeader>c", utils.markdown_insert_codeblock, { buffer = 0, desc = "Insert code block" })
map("n", "tt", utils.markdown_todo_toggle, { buffer = 0, desc = "Toggle To-Do" })
map("n", "<CR>", vim.lsp.buf.definition, { buffer = 0, desc = "Follow link (go to definition)" })

-- local markdown_query = [[
--   (fenced_code_block) @code
--   (fenced_code_block_delimiter) @codedelimiter
-- ]]

-- local namespace = vim.api.nvim_create_namespace("AORITH_RENDER_MARKDOWN")
--
-- local function render_markdown(root)
--   vim.api.nvim_buf_clear_namespace(0, namespace, 0, -1)
--   local query = vim.treesitter.query.parse("markdown", markdown_query)
--   ---@diagnostic disable-next-line: missing-parameter
--   for id, node in query:iter_captures(root, 0) do
--     local capture = query.captures[id]
--     -- local value = vim.treesitter.get_node_text(node, 0)
--     local start_row, start_col, end_row, end_col = node:range()
--     if capture == "codedelimiter" then
--       local marker = string.rep("─", 35)
--       vim.api.nvim_buf_set_extmark(0, namespace, start_row, 0, {
--         virt_text = { { marker, "CursorLineSign" } },
--         virt_text_pos = "eol",
--         priority = 200,
--         right_gravity = false,
--       })
--       -- elseif capture == "code" then
--       --   vim.api.nvim_buf_set_extmark(0, namespace, start_row + 1, 0, {
--       --     end_row = end_row - 1,
--       --     end_col = 0,
--       --     hl_mode = "blend",
--       --     hl_group = "CursorLine",
--       --     hl_eol = true,
--       --   })
--     end
--   end
-- end
--
-- local function render()
--   vim.treesitter.get_parser():for_each_tree(function(tree, language_tree)
--     local language = language_tree:lang()
--     local root = tree:root()
--     if language == "markdown" then render_markdown(root) end
--   end)
-- end
--
-- vim.api.nvim_create_autocmd({
--   "BufEnter",
--   "FileChangedShellPost",
--   "InsertLeave",
--   "Syntax",
--   "TextChanged",
--   "TextChangedI",
-- }, {
--   group = vim.api.nvim_create_augroup("AORITH_MD", { clear = true }),
--   pattern = {
--     "*.md",
--   },
--   callback = function(_) vim.schedule(render) end,
-- })

---@diagnostic disable-next-line: inject-field
vim.b.minihipatterns_config = {
  highlighters = {
    -- Highlight markdown 'tags'
    mdtags = { pattern = "%f[#]()#%w+", group = "Special" },
  },
}

-- Open aerial
vim.cmd("AerialOpen!")
