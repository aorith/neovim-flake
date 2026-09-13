-- apply only if buffer is a file so it does not mess with documentation
if vim.fn.expand('%') == '' then return end

vim.bo.textwidth = 0

local winid = vim.api.nvim_get_current_win()

vim.wo[winid][0].breakindent = true
vim.wo[winid][0].conceallevel = 0
vim.wo[winid][0].wrap = true

-- Check if pandoc supports --math-method=mathml
local math_flag = nil
local function pandoc_math_flag()
  if math_flag == nil then
    local help = vim.system({ 'pandoc', '--help' }, { text = true }):wait()
    math_flag = help.stdout:find('--math-method', 1, true) and '--math-method=mathml' or '--mathml'
  end
  return math_flag
end

local function render_with_pandoc()
  local extra = ('%s/%s/extra'):format(vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. '/.config'), Config.nvim_appname)
  local out = vim.fs.joinpath(vim.fn.stdpath('cache'), 'pandoc-preview.html')

  vim.cmd('silent write')
  vim.system({
    'pandoc',
    '--standalone',
    '--embed-resources', -- inline images/css, so the file stands on its own
    '--toc',
    '--toc-depth=3',
    '--syntax-highlighting=kate', -- token colors are overridden in 'pandoc.css'
    pandoc_math_flag(),
    '--from=markdown',
    '--to=html5',
    '--css=' .. extra .. '/pandoc.css',
    '--include-in-header=' .. extra .. '/pandoc-header.html', -- mermaid & co.
    '--output=' .. out,
    vim.api.nvim_buf_get_name(0),
  }, { text = true }, function(res)
    vim.schedule(function()
      if res.code ~= 0 then
        vim.notify('pandoc: ' .. (res.stderr ~= '' and res.stderr or res.stdout), vim.log.levels.ERROR)
        return
      end
      if res.stderr ~= '' then vim.notify('pandoc: ' .. res.stderr, vim.log.levels.WARN) end
      vim.ui.open(out) -- picks xdg-open/open/wslview for the platform
    end)
  end)
end

Bufmap({ '<Leader>e', render_with_pandoc, desc = 'Convert to HTML and open in a Browser' })

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

Bufmap({ '<TAB>', ']]', remap = true, desc = 'Next header ' })
Bufmap({ '<S-TAB>', '[[', remap = true, desc = 'Previous header' })
Bufmap({ '<LocalLeader>c', markdown_insert_codeblock, desc = 'Insert code block' })
Bufmap({ 'tt', markdown_todo_toggle, desc = 'Toggle checkbox' })
