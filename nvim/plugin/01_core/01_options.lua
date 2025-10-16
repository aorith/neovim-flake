-- Leader keys configuration ---------------------------------------------------
vim.g.mapleader = ' ' -- Leader key must set before plugins
vim.g.maplocalleader = '\\' -- Using ',' breaks: f<letter> + ;,

-- Avoid automatic decompression of files
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
-- I don't think this is required for anything: https://vimhelp.org/pi_getscript.txt.html
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1

--stylua: ignore start

-- General --------------------------------------------------------------------
vim.o.shell        = "bash"   -- Force bash as the shell for '!' commands
vim.o.modelineexpr = false    -- Disable modeline expressions for security
vim.o.backup       = false    -- Don't store backup
vim.o.writebackup  = false    -- Don't store backup
vim.o.mouse        = 'a'      -- Enable mouse
vim.o.undofile     = true     -- Enable persistent undo
vim.o.switchbuf    = 'usetab' -- Use already opened buffers when switching

vim.o.shada = "'100,<50,s10,:1000,/100,@100,h" -- Limit ShaDa file (for startup)

-- Enable all filetype plugins and syntax (if not enabled, for better startup)
vim.cmd("filetype plugin indent on")
if vim.fn.exists("syntax_on") ~= 1 then vim.cmd("syntax enable") end


-- UI -------------------------------------------------------------------------
vim.o.breakindent   = true         -- Indent wrapped lines to match line start
vim.o.breakindentopt = 'list:-1'   -- Add padding for lists when 'wrap' is on
vim.o.colorcolumn   = '+1'         -- Colored column according to 'textwidth' if it's > 0
vim.o.laststatus    = 3            -- Always show statusline
vim.o.linebreak     = true         -- Wrap long lines at 'breakat' (if 'wrap' is set)
vim.o.list          = true         -- Show helpful character indicators
vim.o.number        = true         -- Show line numbers
vim.o.pumblend      = 5            -- Builtin completion menus transparency
vim.o.winblend      = 5            -- Floating windows transparency
vim.o.pumheight     = 10           -- Popup menu size
vim.o.shortmess     = 'CFOSWaco'   -- Disable some built-in completion messages
vim.o.showmode      = false        -- Show mode in command line
vim.o.signcolumn    = 'yes'        -- How signcolumn behaves
vim.o.splitbelow    = true         -- Horizontal splits will be below
vim.o.splitright    = true         -- Vertical splits will be to the right
vim.o.splitkeep     = 'screen'     -- Reduce scroll during a window split
vim.o.wrap          = false        -- Display long lines as just one line
vim.o.showmatch     = true         -- Highlight matching parentheses
vim.o.scrolloff     = 3            -- Scroll context
vim.o.sidescrolloff = 3            -- Line scroll context

vim.o.cursorline    = true                -- Enable highlighting of the current line
vim.o.cursorlineopt = 'screenline,number' -- Show cursor line per screen line


vim.o.fillchars = 'fold:╌,horiz:═,horizdown:╦,horizup:╩,vert:║,verthoriz:╬,vertleft:╣,vertright:╠'
vim.o.listchars = 'extends:…,trail:·,nbsp:␣,precedes:…,tab:> '
vim.o.winborder = "single"

vim.opt.diffopt = { 'internal', 'filler', 'closeoff', 'context:12', 'algorithm:histogram', 'linematch:200', 'indent-heuristic' }

-- Editing --------------------------------------------------------------------
vim.o.autoindent    = true     -- Use auto indent
vim.o.expandtab     = true     -- Convert tabs to spaces
vim.o.formatoptions = 'rqnl1j' -- Improve comment editing
vim.o.ignorecase    = true     -- Ignore case when searching (use `\C` to force not doing that)
vim.o.hlsearch      = true     -- Highlight searches
vim.o.incsearch     = true     -- Show search results while typing
vim.o.infercase     = true     -- Infer letter cases for a richer built-in keyword completion
vim.o.shiftwidth    = 4        -- Use this number of spaces for indentation
vim.o.smartcase     = true     -- Don't ignore case when searching if pattern has upper case
vim.o.smartindent   = true     -- Make indenting smart
vim.o.tabstop       = 4        -- Default tab size
vim.o.softtabstop   = -1       -- Copy shiftwidth value
vim.o.virtualedit   = 'block'  -- Allow going past the end of line in visual block mode
vim.o.confirm       = true     -- Confirm on exit unsaved changes
vim.o.cindent       = true     -- Or else comments do not indent in visualmode + > or <
-- vim.opt.cinkeys:remove("0#")   -- Prevent reindent of comments
vim.o.grepprg = "rg --vimgrep"   -- Configure grep to use ripgrep
vim.o.grepformat = "%f:%l:%c:%m" -- Grep format

-- Spelling -------------------------------------------------------------------
vim.o.spelllang    = 'en,es'      -- Define spelling dictionaries
vim.o.spelloptions = 'camel'      -- Treat parts of camelCase words as separate words
vim.o.complete     = ".,w,b,kspell" -- Use spell check and don't use tags for completion
vim.o.completeopt  = "menuone,noselect,fuzzy,nosort"


-- Folds ----------------------------------------------------------------------
vim.o.foldmethod  = 'indent' -- Set 'indent' folding method
vim.o.foldlevel   = 10       -- Fold nothing by default
vim.o.foldnestmax = 10       -- Limit number of fold levels
vim.o.foldtext    = ''       -- Show text under fold with its highlighting

-- Timers and performance -----------------------------------------------------
vim.o.ttimeoutlen   = 5     -- Milliseconds to wait for a key code sequence to complete
vim.o.timeoutlen    = 700   -- Milliseconds to wait for a mapped sequence to complete
vim.o.updatetime    = 150   -- Affects cursor hold update time
vim.o.lazyredraw    = true  -- Do not redraw when executing macros, registers and other commands
--stylua: ignore end

-- let sqlite.lua know where to find sqlite
-- vim.g.sqlite_clib_path = vim.env.LIBSQLITE

local diagnostic_opts = {
  -- Show signs on top of any other sign, but only for warnings and errors
  signs = { priority = 9999, severity = { min = 'WARN', max = 'ERROR' } },

  -- Show all diagnostics as underline
  underline = { severity = { min = 'HINT', max = 'ERROR' } },

  virtual_lines = false,
  virtual_text = {
    current_line = true,
    severity = { min = 'INFO' },
  },

  -- Don't update diagnostics when typing
  update_in_insert = false,

  severity_sort = true,
  float = { source = true },
}

-- Use `later()` to avoid sourcing `vim.diagnostic` on startup
MiniDeps.later(function() vim.diagnostic.config(diagnostic_opts) end)
