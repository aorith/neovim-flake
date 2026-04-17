-- apply only if buffer is a file so it does not mess with documentation
if vim.fn.expand('%') == '' then return end

vim.bo.textwidth = 0

local winid = vim.api.nvim_get_current_win()

vim.wo[winid][0].number = false
vim.wo[winid][0].signcolumn = 'yes:2'
vim.wo[winid][0].spell = true
vim.wo[winid][0].breakindent = true
vim.wo[winid][0].conceallevel = 0
vim.wo[winid][0].wrap = true

vim.keymap.set(
  'n',
  '<Leader>e',
  "<Cmd>silent w | silent Term sh -c 'pandoc -s --toc --syntax-highlighting kate -f markdown -t html5 -o /tmp/.output.html % -c "
    .. vim.env.XDG_CONFIG_HOME
    .. '/'
    .. Config.nvim_appname
    .. "/extra/pandoc.css && open /tmp/.output.html'"
    .. '<CR>',
  { buffer = 0, desc = 'Run this file with Python' }
)

---@diagnostic disable-next-line: inject-field
vim.b.minihipatterns_config = {
  highlighters = {
    -- Highlight markdown 'tags'
    mdtags = { pattern = '%f[#]()#%w+', group = 'Special' },
  },
}

-- Inserts a new empty code block below the current line
local function markdown_insert_codeblock()
  local win = vim.api.nvim_get_current_win()
  local row, _ = unpack(vim.api.nvim_win_get_cursor(win))

  -- Insert the text in a new line below the current line
  vim.api.nvim_buf_set_lines(0, row, row, false, { '```', '```' })

  local newRow = row + 1 -- Move cursor down one line
  local newCol = 4

  vim.api.nvim_win_set_cursor(win, { newRow, newCol })
end

-- Toggle To-Dos
local function markdown_todo_toggle()
  -- In lua '%' are escape chars
  if string.match(vim.api.nvim_get_current_line(), '- %[ %] ') ~= nil then
    vim.cmd([[
      s/- \[ \] /- \[x\] /g
      nohl
    ]])
  elseif string.match(vim.api.nvim_get_current_line(), '- %[[xX]%] ') ~= nil then
    vim.cmd([[
      s/- \[[xX]\] /- \[ \] /g
      nohl
      ]])
  end
end

vim.keymap.set('n', '<TAB>', ']]', { remap = true, desc = 'Next header ' })
vim.keymap.set('n', '<S-TAB>', '[[', { remap = true, desc = 'Previous header' })
vim.keymap.set('n', '<LocalLeader>c', markdown_insert_codeblock, { desc = 'Insert code block' })
vim.keymap.set('n', 'tt', markdown_todo_toggle, { desc = 'Toggle checkbox' })
