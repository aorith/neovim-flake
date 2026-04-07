-------------------------------------------------------------------------------
-- GLOBALS
-------------------------------------------------------------------------------
_G.Config = {
  nvim_appname = vim.env.NVIM_APPNAME ~= nil and vim.env.NVIM_APPNAME or 'nvim',

  on_nix = (vim.env.NVIM_NIX == '1' or vim.uv.fs_stat('/etc/nixos')) and true or false,

  -- Should be populated after gopls init
  gopls = { goimports_args = nil },
}

-- Define custom autocommand group and helper to create an autocommand.
local gr = vim.api.nvim_create_augroup('ao-custom-config', {})
Config.new_autocmd = function(event, pattern, callback, desc)
  local opts = { group = gr, pattern = pattern, callback = callback, desc = desc }
  vim.api.nvim_create_autocmd(event, opts)
end

-- Define custom `vim.pack.add()` hook helper. See `:h vim.pack-events`.
Config.on_packchanged = function(plugin_name, kinds, callback, desc)
  local f = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then return end
    if not ev.data.active then vim.cmd.packadd(plugin_name) end
    callback(ev.data)
  end
  Config.new_autocmd('PackChanged', '*', f, desc)
end

-- Define a custom function to run commands in a terminal.
Config.run_in_terminal = function(cmd)
  if cmd == nil or cmd == '' then
    vim.ui.input({ prompt = 'Command to run: ' }, function(input)
      if input and input ~= '' then Config.run_in_terminal(input) end
    end)
    return
  end

  local expanded = vim.fn.expandcmd(cmd)
  vim.print(expanded)
  vim.cmd('terminal ' .. expanded)
end

vim.api.nvim_create_user_command(
  'Term',
  function(opts) Config.run_in_terminal(opts.args ~= '' and opts.args or nil) end,
  { nargs = '?', desc = 'Run command in a terminal' }
)

-------------------------------------------------------------------------------
-- OPTIONS
-------------------------------------------------------------------------------
vim.g.mapleader = ' ' -- Leader key must set before plugins
vim.g.maplocalleader = '\\' -- Using ',' breaks: f<letter> + ;,

-- Avoid automatic decompression of files
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1

-- Enable all filetype plugins and syntax (if not enabled, for better startup)
vim.cmd('filetype plugin indent on')
if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end

-- Set LSP log level
vim.lsp.log.set_level(vim.log.levels.ERROR)

--stylua: ignore start
-- UI -------------------------------------------------------------------------
vim.o.undofile       = true         -- Enable persistent undo
vim.o.breakindent    = true         -- Indent wrapped lines to match line start
vim.o.breakindentopt = 'list:-1'    -- Add padding for lists when 'wrap' is on
vim.o.colorcolumn    = '+1'         -- Colored column according to 'textwidth' if it's > 0
vim.o.linebreak      = true         -- Wrap long lines at 'breakat' (if 'wrap' is set)
vim.o.list           = true         -- Show helpful character indicators
vim.o.number         = true         -- Show line numbers
vim.o.signcolumn     = 'yes'        -- How signcolumn behaves
vim.o.splitbelow     = true         -- Horizontal splits will be below
vim.o.splitright     = true         -- Vertical splits will be to the right
vim.o.wrap           = false        -- Display long lines as just one line
vim.o.showmatch      = true         -- Highlight matching parentheses
vim.o.scrolloff      = 3            -- Scroll context
vim.o.sidescrolloff  = 3            -- Line scroll context
vim.o.termguicolors  = true         -- It should be auto-detected, but weird combinations with ssh/nixos/tmux disable it

vim.o.fillchars = 'fold:╌,horiz:═,horizdown:╦,horizup:╩,vert:║,verthoriz:╬,vertleft:╣,vertright:╠'
vim.o.listchars = 'extends:…,trail:·,nbsp:␣,precedes:…,tab:> '
vim.o.winborder = 'rounded'

-- Editing --------------------------------------------------------------------
vim.o.expandtab     = true     -- Convert tabs to spaces
vim.o.formatoptions = 'rqnl1j' -- Improve comment editing
vim.o.ignorecase    = true     -- Ignore case when searching (use `\C` to force not doing that)
vim.o.infercase     = true     -- Infer case in built-in completion
vim.o.shiftwidth    = 4        -- Use this number of spaces for indentation
vim.o.smartcase     = true     -- Don't ignore case when searching if pattern has upper case
vim.o.smartindent   = true     -- Make indenting smart
vim.o.tabstop       = 4        -- Default tab size
vim.o.softtabstop   = -1       -- Copy shiftwidth value
vim.o.virtualedit   = 'block'  -- Allow going past the end of line in visual block mode
vim.o.confirm       = true     -- Confirm on exit unsaved changes

vim.o.grepformat    = '%f:%l:%c:%m'               -- Ripgrep format
vim.o.grepprg       = 'rg --vimgrep --smart-case' -- Configure grep to use ripgrep

vim.o.completeopt     = "menuone,noselect,fuzzy,nosort" -- Completion options
vim.o.completetimeout = 150                             -- Limit completion sources delay

-- Spelling -------------------------------------------------------------------
vim.o.spelllang       = 'en,es'        -- Define spelling dictionaries
vim.o.spelloptions    = 'camel'        -- Treat parts of camelCase words as separate words

--stylua: ignore end

-------------------------------------------------------------------------------
-- BIGFILE DETECTION
-------------------------------------------------------------------------------
-- Bigfile (https://github.com/folke/snacks.nvim/blob/e937bfaa741c4ac7379026b09ec252bd7a9409a6/lua/snacks/bigfile.lua#L19C1-L32C5)
local size = 1.5 * 1024 * 1024 -- 1.5MB

vim.filetype.add({
  pattern = {
    ['.*'] = {
      function(path, buf)
        return vim.bo[buf] and vim.bo[buf].filetype ~= 'bigfile' and path and vim.fn.getfsize(path) > size and 'bigfile'
          or nil
      end,
    },
  },
})

local function on_bigfile(ev)
  vim.b.minianimate_disable = true
  vim.schedule(function()
    vim.bo[ev.buf].syntax = ev.ft

    local winid = vim.api.nvim_get_current_win()
    vim.wo[winid][0].cursorlineopt = 'number'
  end)
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(ev.buf), ':p:~:.')
  vim.notify(('Big file detected `%s`.'):format(path))
end

Config.new_autocmd('FileType', 'bigfile', function(ev)
  vim.api.nvim_buf_call(
    ev.buf,
    function()
      on_bigfile({
        buf = ev.buf,
        ft = vim.filetype.match({ buf = ev.buf }) or '',
      })
    end
  )
end, 'Bigfile')

-------------------------------------------------------------------------------
-- AUTOCOMMANDS
-------------------------------------------------------------------------------
-- Autoread on focus (required by tmux)
Config.new_autocmd('FocusGained', nil, function() vim.cmd('checktime') end, 'Autoread on focus gained')

-- Highlight on yank
Config.new_autocmd('TextYankPost', nil, function() vim.hl.on_yank() end, 'Highlight on yank')

-- Go to the last line edited when opening a file
Config.new_autocmd('BufReadPost', nil, function(data)
  -- skip some filetypes
  if
    vim.tbl_contains({ 'minifiles', 'minipick', 'gitcommit' }, vim.bo.filetype)
    or vim.bo.buftype == 'prompt'
    or vim.bo.buftype == 'help'
  then
    return
  end
  local last_pos = vim.api.nvim_buf_get_mark(data.buf, '"')
  if last_pos[1] > 0 and last_pos[1] <= vim.api.nvim_buf_line_count(data.buf) then
    vim.api.nvim_win_set_cursor(0, last_pos)
  end
end, 'Go to the last known line of the file')

-- close some filetypes with <q>
Config.new_autocmd('FileType', {
  'git',
  'diff',
  'help',
  'lspinfo',
  'man',
  'notify',
  'qf',
  'spectre_panel',
  'nvim-undotree',
}, function(event)
  vim.bo[event.buf].buflisted = false
  vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
end, "Close file with 'q'")

-- Don't auto-wrap comments and don't insert comment leader after hitting 'o'.
-- Do on `FileType` to always override these changes from filetype plugins.
Config.new_autocmd(
  'FileType',
  nil,
  function() vim.cmd('setlocal formatoptions-=c formatoptions-=o') end,
  "Proper 'formatoptions'"
)

-- Theme overrides
Config.new_autocmd('ColorScheme', nil, function()
  -- Ensure that mini.cursorword always highlights without using underline
  -- vim.api.nvim_set_hl(0, "MiniCursorWord", { link = "Visual" })
  -- vim.api.nvim_set_hl(0, "MiniCursorWordCurrent", { link = "Visual" })

  -- Transparency
  -- vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
  -- vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
  -- vim.api.nvim_set_hl(0, 'MiniPickNormal', { bg = 'none' })
  -- vim.api.nvim_set_hl(0, 'MiniFilesNormal', { bg = 'none' })

  -- Make MiniJump more noticeable
  vim.api.nvim_set_hl(0, 'MiniJump', { link = 'Search' })
  -- and MatchParen
  vim.api.nvim_set_hl(0, 'MatchParen', { link = 'Search' })

  -- treesitter.context
  vim.api.nvim_set_hl(0, 'TreesitterContextLineNumber', { link = 'TreesitterContext' })
end, 'Theme overrides')

-------------------------------------------------------------------------------
-- DIAGNOSTICS CONFIG
-------------------------------------------------------------------------------
vim.diagnostic.config({
  signs = {
    priority = 9999,
    severity = { min = vim.diagnostic.severity.WARN, max = vim.diagnostic.severity.ERROR },
  },
  underline = { severity = { min = vim.diagnostic.severity.HINT, max = vim.diagnostic.severity.ERROR } },
  virtual_lines = false,
  virtual_text = {
    current_line = true,
    severity = { min = vim.diagnostic.severity.INFO },
  },
  update_in_insert = false,
  severity_sort = true,
  float = { source = true },
})
