--stylua: ignore start

-- Leader keys configuration ---------------------------------------------------
vim.g.mapleader = " "      -- Leader key must set before plugins
vim.g.maplocalleader = " " -- Using ',' breaks: f<letter> + ;,

-- Disable builtin plugins to improve loading time -----------------------------
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
-- vim.g.loaded_netrwSettings = 1
-- vim.g.loaded_netrwFileHandlers = 1

-- General --------------------------------------------------------------------
vim.o.shell        = "bash"   -- Force bash as the shell for '!' commands
vim.o.modelineexpr = false    -- Disable modeline expressions for security
vim.o.backup       = false    -- Don't store backup
vim.o.writebackup  = false    -- Don't store backup
vim.o.mouse        = 'a'      -- Enable mouse
vim.o.undofile     = true     -- Enable persistent undo
vim.opt.path:append("**")     -- Search down into subfolders

-- Enable filetype plugins
vim.cmd.filetype("plugin", "indent", "on")

-- UI -------------------------------------------------------------------------
vim.o.breakindent   = true         -- Indent wrapped lines to match line start
vim.o.colorcolumn   = '+1'         -- Colored column according to 'textwidth' if it's > 0
vim.o.cursorline    = true         -- Enable highlighting of the current line
vim.o.cursorlineopt = "number"     -- Cursorline highlights only the number column
vim.o.laststatus    = 2            -- Always show statusline
vim.o.linebreak     = true         -- Wrap long lines at 'breakat' (if 'wrap' is set)
vim.o.list          = true         -- Show helpful character indicators
vim.o.number        = true         -- Show line numbers
vim.o.pumblend      = 0            -- Builtin completion menus transparency
vim.o.winblend      = 0            -- Floating windows transparency
vim.o.pumheight     = 12           -- Popup menu size
vim.o.ruler         = false        -- Don't show cursor position
vim.o.shortmess     = 'aoOTtWFCcS' -- Disable certain messages from |ins-completion-menu|
vim.o.showmode      = false        -- Don't show mode in command line
vim.o.showtabline   = 2            -- Always show tabline
vim.o.signcolumn    = 'yes'        -- Always show signcolumn or it would frequently shift
vim.o.splitbelow    = true         -- Horizontal splits will be below
vim.o.splitright    = true         -- Vertical splits will be to the right
vim.o.splitkeep     = 'screen'     -- Reduce scroll during a window split
vim.o.wrap          = false        -- Display long lines as just one line
vim.o.showmatch     = true         -- Highlight matching parentheses

vim.o.fillchars = table.concat(
  { 'eob: ', 'fold:╌', 'horiz:═', 'horizdown:╦', 'horizup:╩', 'vert:║', 'verthoriz:╬', 'vertleft:╣', 'vertright:╠' },
  ','
)
vim.o.listchars = table.concat({ 'extends:…', 'trail:·', 'nbsp:␣', 'precedes:…', 'tab:> ' }, ',')

-- Enable syntax highlighting
if vim.fn.exists("syntax_on") ~= 1 then vim.cmd("syntax enable") end

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
vim.o.tabstop       = 8        -- Default tab size
vim.o.softtabstop   = -1       -- Copy shiftwidth value
vim.o.virtualedit   = 'block'  -- Allow going past the end of line in visual block mode
vim.o.confirm       = true     -- Confirm on exit unsaved changes
vim.o.cindent       = true     -- Or else comments do not indent in visualmode + > or <
vim.opt.cinkeys:remove("0#")   -- Prevent reindent of comments
vim.o.grepprg = "rg --vimgrep"   -- Configure grep to use ripgrep
vim.o.grepformat = "%f:%l:%c:%m" -- Grep format

vim.opt.completeopt = { "menu", "menuone", "noselect", "preview" }

-- Spelling -------------------------------------------------------------------
vim.opt.spelllang    = 'en_us,es' -- Define spelling dictionaries
vim.opt.spelloptions = 'camel'    -- Treat parts of camelCase words as separate words
vim.opt.complete:append('kspell') -- Add spellcheck options for autocomplete
vim.opt.complete:remove('t')      -- Don't use tags for completion

-- Folds ----------------------------------------------------------------------
vim.o.foldmethod       = 'indent' -- Set 'indent' folding method
vim.o.foldlevel        = 1        -- Display all folds except top ones
vim.o.foldlevelstart   = 99       -- Start with all folds open
vim.o.foldnestmax      = 10       -- Create folds only for some number of nested levels

-- Timers and performance -----------------------------------------------------
vim.o.ttimeoutlen   = 5     -- Milliseconds to wait for a key code sequence to complete
vim.o.timeoutlen    = 700   -- Milliseconds to wait for a mapped sequence to complete
vim.o.updatetime    = 250   -- Affects cursor hold update time
vim.o.lazyredraw    = true  -- Do not redraw when executing macros, registers and other commands

-- let sqlite.lua know where to find sqlite
vim.g.sqlite_clib_path = vim.fn.getenv("LIBSQLITE")

--stylua: ignore end
