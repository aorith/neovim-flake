local g = vim.g
local opt = vim.opt

-- Leader keys configuration
g.mapleader, g.maplocalleader = " ", ","

-- Disable builtin plugins to improve loading time
g.loaded_gzip = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1
g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_2html_plugin = 1
g.loaded_logiPat = 1
g.loaded_rrhelper = 1
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_netrwSettings = 1
g.loaded_netrwFileHandlers = 1

-- General options
opt.modelineexpr = false -- Disable modeline expressions for security
opt.undofile = true
opt.backup, opt.writebackup = false, false -- Disable file backups
opt.path:append("**") -- Search down into subfolders

-- UI and editor behavior
opt.completeopt = "menuone,noinsert,noselect,preview"
opt.confirm = true -- Confirm on exit unsaved changes
opt.mouse = "a"
opt.number = true
opt.showmatch = true -- Highlight matching parentheses
opt.showmode = false
opt.cursorline, opt.cursorlineopt = true, "number" -- Highlight cursor line and only the line number
opt.hlsearch, opt.ignorecase, opt.incsearch, opt.infercase, opt.smartcase = true, true, true, true, true -- Search options
opt.signcolumn = "yes:1"
opt.colorcolumn = "+1" -- Highlight column beyond 'textwidth'
opt.pumblend, opt.pumheight, opt.winblend = 0, 12, 0 -- Popup menu appearance
opt.termguicolors = true

-- Indentation and formatting
opt.autoindent, opt.smartindent = true, true -- Auto indenting and smart indenting
opt.expandtab = true -- Spaces instead of tabs
opt.shiftwidth = 4 -- TAB equals 4 spaces
opt.tabstop = 8 -- Default tab size
opt.softtabstop = -1 -- Copy shiftwidth value
opt.breakindent = true -- Indent wrapped lines
opt.wrap = false -- Disable line wrap
opt.linebreak = true -- Enable line break on words
opt.cindent = true -- Or else comments do not indent in visualmode + > or <

-- Timers and performance
opt.timeoutlen, opt.updatetime = 400, 300 -- Command timeout lengths and cursor hold update time
opt.lazyredraw = true

-- Window and buffer management
opt.splitkeep, opt.splitright, opt.splitbelow = "screen", true, true -- Split window preferences
opt.foldlevel, opt.foldnestmax, opt.foldlevelstart = 1, 5, 99 -- Fold configuration

-- Searching and pattern matching
opt.grepformat, opt.grepprg = "%f:%l:%c:%m", "rg --vimgrep" -- Configure grep to use ripgrep and its format

-- Miscellaneous options
opt.shortmess:append({ W = true, I = true, c = true, C = true }) -- Configure short message options to reduce clutter
opt.sidescrolloff = 8 -- Context around cursor
opt.winminwidth = 5
opt.diffopt:append({ "linematch:50", "vertical", "foldcolumn:0", "indent-heuristic" }) -- Diff options for better comparison view
opt.history = 100
opt.report = 0
opt.ruler = false
opt.formatoptions = "qjl1"
opt.laststatus = 2
opt.spelllang, opt.spelloptions = "en,es", "camel" -- Spell check configuration
opt.listchars = { tab = ">-", trail = "·", nbsp = "␣", extends = "…", precedes = "…" } -- Visual representation of certain characters

-- let sqlite.lua (which some plugins depend on) know where to find sqlite
g.sqlite_clib_path = require("luv").os_getenv("LIBSQLITE")

-- Enable filetype plugins
vim.cmd.filetype("plugin", "indent", "on")
-- Enable syntax highlighting
vim.cmd("syntax enable")

-- Use signs for diagnostics in the gutter
vim.fn.sign_define("DiagnosticSignError", { text = "󰅚", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "󰀪", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "󰋽", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "󰌶", texthl = "DiagnosticSignHint" })
