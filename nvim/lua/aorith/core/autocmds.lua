local A = vim.api
local my_au = A.nvim_create_augroup("AORITH", { clear = true })

-- Highlight on yank
A.nvim_create_autocmd("TextYankPost", {
  group = my_au,
  callback = function() vim.hl.on_yank() end,
})

-- NOTE: interferes with nvim-dap
-- Tweak terminal on open and go into insert mode
-- A.nvim_create_autocmd("TermOpen", {
--   group = my_au,
--   callback = function()
--     vim.opt.number = false
--     vim.opt.relativenumber = false
--     vim.opt.signcolumn = "no"
--     A.nvim_command("startinsert")
--   end,
-- })

-- Automatically close terminal Buffers when their Process is done
-- vim.api.nvim_create_autocmd("TermClose", {
--   group = my_au,
--   callback = function() vim.cmd("bdelete") end,
-- })

-- go to the last line before closing the file
A.nvim_create_autocmd("BufReadPost", {
  group = my_au,
  callback = function(data)
    -- skip some filetypes
    if vim.tbl_contains({ "minifiles", "minipick", "snacks_picker_input", "gitcommit" }, vim.bo.filetype) or vim.bo.buftype == "prompt" then return end
    local last_pos = A.nvim_buf_get_mark(data.buf, '"')
    if last_pos[1] > 0 and last_pos[1] <= A.nvim_buf_line_count(data.buf) then A.nvim_win_set_cursor(0, last_pos) end
  end,
})

-- close some filetypes with <q>
A.nvim_create_autocmd("FileType", {
  group = my_au,
  pattern = {
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "spectre_panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Dont format or add comment string on newline
A.nvim_create_autocmd("FileType", {
  group = my_au,
  callback = function() vim.cmd("setlocal formatoptions-=c formatoptions-=r formatoptions-=o") end,
  desc = "Ensure proper 'formatoptions'",
})

-- Theme overrides
A.nvim_create_autocmd("ColorScheme", {
  group = my_au,
  pattern = "*",
  callback = function()
    -- Ensure that mini.cursorword always highlights without using underline
    vim.api.nvim_set_hl(0, "MiniCursorWord", { link = "Visual" })
    vim.api.nvim_set_hl(0, "MiniCursorWordCurrent", { link = "Visual" })

    -- Make MiniJump more noticeable
    vim.api.nvim_set_hl(0, "MiniJump", { link = "Search" })

    My.hi("Comment", { italic = true })
    My.hi("@comment.error", { italic = true })
    My.hi("@comment.warning", { italic = true })
    My.hi("@comment.todo", { italic = true })
    My.hi("@comment.note", { italic = true })

    -- treesitter.context
    vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { link = "TreesitterContext" })
  end,
})
