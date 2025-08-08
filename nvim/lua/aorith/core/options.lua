-- Leader keys configuration ---------------------------------------------------
vim.g.mapleader = " " -- Leader key must set before plugins
vim.g.maplocalleader = "\\" -- Using ',' breaks: f<letter> + ;,

-- Enable filetype plugins
vim.cmd("filetype plugin indent on")
-- Enable syntax highlighting if it wasn't already (as it is time consuming)
if vim.fn.exists("syntax_on") ~= 1 then vim.cmd("syntax enable") end

--stylua: ignore start
-- General --------------------------------------------------------------------
vim.o.shell        = "bash"   -- Force bash as the shell for '!' commands
vim.o.modelineexpr = false    -- Disable modeline expressions for security
vim.o.backup       = false    -- Don't store backup
vim.o.writebackup  = false    -- Don't store backup
vim.o.mouse        = 'a'      -- Enable mouse
vim.o.undofile     = true     -- Enable persistent undo


-- UI -------------------------------------------------------------------------
vim.o.breakindent   = true         -- Indent wrapped lines to match line start
vim.o.breakindentopt = 'list:-1'   -- Add padding for lists when 'wrap' is on
vim.o.colorcolumn   = '+1'         -- Colored column according to 'textwidth' if it's > 0
vim.o.cursorline    = true         -- Enable highlighting of the current line
vim.o.cursorlineopt = 'number'     -- Highlight only the number, both and or screenline messes up some treesitter highlights
vim.o.laststatus    = 3            -- Always show statusline
vim.o.linebreak     = true         -- Wrap long lines at 'breakat' (if 'wrap' is set)
vim.o.list          = true         -- Show helpful character indicators
vim.o.number        = true         -- Show line numbers
vim.o.pumblend      = 0            -- Builtin completion menus transparency
vim.o.winblend      = 0            -- Floating windows transparency
vim.o.pumheight     = 12           -- Popup menu size
vim.o.shortmess     = 'aoOTtWFCcS' -- Disable certain messages from |ins-completion-menu|
vim.o.showmode      = false        -- Show mode in command line
vim.o.signcolumn    = 'yes'        -- How signcolumn behaves
vim.o.splitbelow    = true         -- Horizontal splits will be below
vim.o.splitright    = true         -- Vertical splits will be to the right
vim.o.splitkeep     = 'screen'     -- Reduce scroll during a window split
vim.o.wrap          = false        -- Display long lines as just one line
vim.o.showmatch     = true         -- Highlight matching parentheses
vim.o.scrolloff     = 3            -- Scroll context
vim.o.sidescrolloff = 3            -- Line scroll context

vim.o.fillchars = table.concat(
  { 'fold:╌', 'horiz:═', 'horizdown:╦', 'horizup:╩', 'vert:║', 'verthoriz:╬', 'vertleft:╣', 'vertright:╠' },
  ','
)
vim.o.listchars = table.concat({ 'extends:…', 'trail:·', 'nbsp:␣', 'precedes:…', 'tab:> ' }, ',')
vim.o.winborder = "rounded"

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
vim.o.complete     = ".,b,kspell" -- Use spell check and don't use tags for completion

-- Folds ----------------------------------------------------------------------
vim.o.foldmethod       = 'indent' -- Set 'indent' folding method
vim.o.foldlevel        = 1        -- Display all folds except top ones
vim.o.foldlevelstart   = 99       -- Start with all folds open
vim.o.foldnestmax      = 10       -- Create folds only for some number of nested levels

-- Timers and performance -----------------------------------------------------
vim.o.ttimeoutlen   = 5     -- Milliseconds to wait for a key code sequence to complete
vim.o.timeoutlen    = 700   -- Milliseconds to wait for a mapped sequence to complete
vim.o.updatetime    = 150   -- Affects cursor hold update time
vim.o.lazyredraw    = true  -- Do not redraw when executing macros, registers and other commands

-- let sqlite.lua know where to find sqlite
-- vim.g.sqlite_clib_path = vim.fn.getenv("LIBSQLITE")

--stylua: ignore end
