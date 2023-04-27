local nvim_appname = require("core.utils").nvim_appname

-- leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Ensure nomodelineexpr
vim.opt.modelineexpr = false

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Disable perl provider
vim.g.loaded_perl_provider = 0

-- backup, swap and directory configuration
vim.opt.viminfo:append("n" .. vim.fn.getenv("HOME") .. "/.local/share/" .. nvim_appname .. "/viminfo")
vim.opt.undofile = true
vim.opt.undodir = vim.fn.getenv("HOME") .. "/.local/share/" .. nvim_appname .. "/undodir//"
vim.opt.backup = true
vim.opt.backupdir = vim.fn.getenv("HOME") .. "/.local/share/" .. nvim_appname .. "/backup//"
vim.opt.swapfile = true
vim.opt.directory = vim.fn.getenv("HOME") .. "/.local/share/" .. nvim_appname .. "/swap//"

-- encoding and ff
vim.opt.encoding = "utf8"
vim.opt.fileformats = "unix,dos,mac"

-- misc
vim.opt.cinkeys:remove("0#") -- don't reindent on # char
vim.opt.confirm = true -- confirm to save changes before exiting a modified buffer
vim.opt.diffopt:append({ "linematch:50" }) -- better diff: https://github.com/neovim/neovim/pull/14537
vim.opt.formatoptions = "qjl"
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.report = 0 -- Always report the number of lines changed after :command
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
vim.opt.showmode = false -- don't show mode - it's shown in the statusline
vim.opt.winminwidth = 5 -- Minimum window width
vim.wo.signcolumn = "yes" -- Show sign column, "yes:3" max 3 signs

-- context
vim.opt.scrolloff = 4 -- Lines of context
vim.opt.sidescrolloff = 8 -- Columns of context

-- list chars
vim.opt.list = false
vim.opt.listchars = {
  tab = ">-",
  trail = "·",
  nbsp = "+",
  extends = "…",
  precedes = "…",
}

-- cursorline
vim.opt.cursorline = true -- Highlight cursor line
vim.opt.cursorlineopt = "number" --only highlight the number

-- search
vim.opt.hlsearch = true
vim.opt.ignorecase = true -- Ignore case
vim.opt.incsearch = true
vim.opt.smartcase = true -- Disable ignorecase when the search term contains upper case characters

-- tabs and indent
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.softtabstop = -1
vim.opt.tabstop = 4

-- timers
vim.opt.timeoutlen = 400
vim.opt.updatetime = 300 -- For CursorHold and swapfile

-- wrap
vim.opt.wrap = false
vim.opt.showbreak = "↳ "

-- splits
vim.opt.splitkeep = "screen"
vim.opt.splitright = true
vim.opt.splitbelow = true
-- characters used in the splits
vim.opt.fillchars:append({
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┨",
  vertright = "┣",
  verthoriz = "╋",
})

-- grep
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
