-------------------------------------------------------------------------------
-- GLOBALS
-------------------------------------------------------------------------------
require('config.utils')

_G.Config = {
  nvim_appname = vim.env.NVIM_APPNAME or 'nvim',
  notes_dir = vim.env.HOME .. '/Syncthing/SYNC_STUFF/notes/md',

  on_nix = (vim.env.NVIM_NIX == '1' or vim.uv.fs_stat('/etc/nixos')) and true or false,

  -- Should be populated after gopls init
  gopls = { goimports_args = nil },
}

vim.api.nvim_create_user_command(
  'Term',
  function(opts) RunInTerminal(opts.args ~= '' and opts.args or nil) end,
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

-- Set LSP log level
vim.lsp.log.set_level(vim.log.levels.ERROR)

--stylua: ignore start
-- UI -------------------------------------------------------------------------
vim.o.breakindent    = true         -- Indent wrapped lines to match line start
vim.o.breakindentopt = 'list:-1'    -- Add padding for lists when 'wrap' is on
vim.o.colorcolumn    = '+1'         -- Colored column according to 'textwidth' if it's > 0
vim.o.linebreak      = true         -- Wrap long lines at 'breakat' (if 'wrap' is set)
vim.o.list           = true         -- Show helpful character indicators
vim.o.number         = true         -- Show line numbers
vim.o.signcolumn     = 'yes'        -- How signcolumn behaves
vim.o.cursorline     = true
vim.o.splitbelow     = true         -- Horizontal splits will be below
vim.o.splitright     = true         -- Vertical splits will be to the right
vim.o.wrap           = false        -- Display long lines as just one line
vim.o.showmatch      = true         -- Highlight matching parentheses
vim.o.scrolloff      = 3            -- Scroll context
vim.o.sidescrolloff  = 3            -- Line scroll context
vim.o.foldlevel      = 99           -- No fold by default
vim.o.termguicolors  = true         -- It should be auto-detected, but weird combinations with ssh/nixos/tmux disable it
vim.o.scrollback     = 99999        -- Increase terminal scrollback buffer

vim.o.fillchars = 'fold:╌,horiz:═,horizdown:╦,horizup:╩,vert:║,verthoriz:╬,vertleft:╣,vertright:╠'
vim.o.listchars = 'extends:…,trail:·,nbsp:␣,precedes:…,tab:> '
vim.o.winborder = 'rounded'

-- Editing --------------------------------------------------------------------
vim.o.backup    = true
vim.o.backupdir = vim.fn.stdpath('state') .. '/backup//'
vim.o.undofile  = true
vim.o.undodir   = vim.fn.stdpath('state') .. '/undo//'

vim.o.expandtab     = true     -- Convert tabs to spaces
vim.o.formatoptions = 'rqnl1j' -- Improve comment editing
vim.o.ignorecase    = true     -- Ignore case when searching (use `\C` to force not doing that)
vim.o.infercase     = true     -- Infer case in built-in completion
vim.o.shiftround    = true     -- Round indent to a multiple of 'shiftwidth'
vim.o.shiftwidth    = 4        -- Use this number of spaces for indentation
vim.o.smartcase     = true     -- Don't ignore case when searching if pattern has upper case
vim.o.smartindent   = true     -- Make indenting smart
vim.o.smoothscroll  = true     -- Scroll by screen line, not buffer line, when 'wrap' is set
vim.o.tabstop       = 4        -- Default tab size
vim.o.softtabstop   = -1       -- Copy shiftwidth value
vim.o.virtualedit   = 'block'  -- Allow going past the end of line in visual block mode
vim.o.confirm       = true     -- Confirm on exit unsaved changes
vim.o.inccommand    = 'split'  -- Show changes in a split while running an :%s/aa/bb command
vim.o.undolevels    = 10000    -- Increase default undo history size (default 1000)
vim.o.updatetime    = 200      -- Faster CursorHold / swap-file write (default 4000ms)

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

NewAutocmd('bigfile', nil, 'FileType', 'bigfile', function(ev)
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
-- Autoread on focus/terminal events (required by tmux); skip scratch buffers
NewAutocmd('autoread-focus', nil, { 'FocusGained', 'TermClose', 'TermLeave' }, nil, function()
  if vim.bo.buftype ~= 'nofile' then vim.cmd('checktime') end
end, 'Autoread on focus/terminal events')

-- Highlight on yank
NewAutocmd('hl-yank', nil, 'TextYankPost', nil, function() vim.hl.on_yank() end, 'Highlight on yank')

-- Re-equalize splits when the terminal is resized
NewAutocmd('resize-splits', nil, 'VimResized', nil, function()
  local current_tab = vim.fn.tabpagenr()
  vim.cmd('tabdo wincmd =')
  vim.cmd('tabnext ' .. current_tab)
end, 'Equalize splits on resize')

-- close some filetypes with <q>
NewAutocmd('close-on-q', nil, 'FileType', {
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
  Bufmap({ 'q', '<cmd>close<cr>', silent = true })
end, "Close file with 'q'")

-- Don't auto-wrap comments and don't insert comment leader after hitting 'o'.
-- Do on `FileType` to always override these changes from filetype plugins.
NewAutocmd(
  'no-auto-wrap',
  nil,
  'FileType',
  nil,
  function() vim.cmd('setlocal formatoptions-=c formatoptions-=o') end,
  "Proper 'formatoptions'"
)

-- Theme overrides
NewAutocmd('theme-overrides', nil, 'ColorScheme', nil, function()
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
