-- Disabled built-in plugins
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1

-- General
vim.g.clipboard = 'osc52' -- Force OSC52 even on ssh+tmux
vim.o.confirm = true -- Ask instead of failing when quitting with unsaved changes
vim.o.updatetime = 200 -- Faster CursorHold / swap-file write (default 4000ms)

-- Appearance
vim.o.number = true
vim.o.signcolumn = 'yes' -- Always reserve it, so the text doesn't shift around
vim.o.cursorline = true
vim.o.colorcolumn = '+1' -- Follows 'textwidth', hidden while it is 0
vim.o.showmatch = true -- Briefly jump to the matching bracket when typing one
vim.o.termguicolors = true -- Should be auto-detected, but ssh/nixos/tmux combos disable it
vim.o.winborder = 'rounded'
vim.o.list = true -- Show the indicators below
vim.o.listchars = 'extends:…,trail:·,nbsp:␣,precedes:…,tab:> '
vim.o.fillchars = 'fold:╌,horiz:═,horizdown:╦,horizup:╩,vert:║,verthoriz:╬,vertleft:╣,vertright:╠'

-- Line wrapping
vim.o.wrap = false
vim.o.linebreak = true -- Break at 'breakat' instead of mid-word
vim.o.breakindent = true -- Indent wrapped lines to match the line start
vim.o.breakindentopt = 'list:-1' -- Pad wrapped list items
vim.o.smoothscroll = true -- Scroll by screen line, not by buffer line

-- Splits and scrolling
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.scrolloff = 3 -- Lines to keep above/below the cursor
vim.o.sidescrolloff = 3 -- Same, horizontally
vim.o.scrollback = 99999 -- Terminal buffer history

-- Indentation
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = -1 -- Follow 'shiftwidth'
vim.o.shiftround = true -- Round '<'/'>' to a multiple of 'shiftwidth'
vim.o.smartindent = true

-- Editing
vim.o.formatoptions = 'rqnl1j' -- The 'c' and 'o' flags are stripped in 'plugin/01_autocmds.lua'
vim.o.virtualedit = 'block' -- Allow going past the end of line in visual block mode

-- Search
vim.o.ignorecase = true -- Use '\C' in the pattern to force a case sensitive search
vim.o.smartcase = true -- ... unless the pattern has an upper case character
vim.o.inccommand = 'split' -- Preview ':%s/aa/bb' results in a split

-- Folding
vim.o.foldlevel = 99 -- Start with everything unfolded

-- Backup and undo
vim.o.backup = true
vim.o.backupdir = vim.fn.stdpath('state') .. '/backup//'
vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath('state') .. '/undo//'
vim.o.undolevels = 10000 -- Default is 1000

-- Completion
vim.o.completeopt = 'menuone,noselect,fuzzy,nosort'
vim.o.completetimeout = 150 -- Limit completion sources delay
vim.o.infercase = true -- Infer case in built-in completion

-- Spelling
vim.o.spelllang = 'en,es'
vim.o.spelloptions = 'camel' -- Treat parts of camelCase words as separate words

-- Grep
vim.o.grepprg = 'rg --vimgrep --smart-case'
vim.o.grepformat = '%f:%l:%c:%m'

-- Diagnostics
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
