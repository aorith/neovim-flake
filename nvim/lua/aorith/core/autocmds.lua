local A = vim.api
local my_au = A.nvim_create_augroup("AORITH", { clear = true })

-- Highlight on yank
A.nvim_create_autocmd("TextYankPost", {
  group = my_au,
  callback = function() vim.hl.on_yank() end,
})

-- Go to the last line edited when opening a file
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
    -- vim.api.nvim_set_hl(0, "MiniCursorWord", { link = "Visual" })
    -- vim.api.nvim_set_hl(0, "MiniCursorWordCurrent", { link = "Visual" })

    -- Make MiniJump more noticeable
    vim.api.nvim_set_hl(0, "MiniJump", { link = "Search" })

    _G.Config.hi("Comment", { italic = true })
    _G.Config.hi("@comment.error", { italic = true })
    _G.Config.hi("@comment.warning", { italic = true })
    _G.Config.hi("@comment.todo", { italic = true })
    _G.Config.hi("@comment.note", { italic = true })

    -- treesitter.context
    vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { link = "TreesitterContext" })
  end,
})
