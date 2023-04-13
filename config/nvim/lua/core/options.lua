vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Ensure nomodelineexpr
vim.opt.modelineexpr = false

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Disable perl provider
vim.g.loaded_perl_provider = 0

vim.opt.autoindent = true
vim.opt.clipboard = "unnamed" -- don't copy to the system clipboard
vim.opt.confirm = true -- confirm to save changes before exiting a modified buffer
vim.opt.cursorline = true -- Highlight cursor line
vim.opt.cursorlineopt = "number"
vim.opt.diffopt:append({ "linematch:50" }) -- https://github.com/neovim/neovim/pull/14537
vim.opt.encoding = "utf-8"
vim.opt.expandtab = true
vim.opt.formatoptions = "jnlq"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.hlsearch = true
vim.opt.ignorecase = true -- Ignore case
vim.opt.incsearch = true
vim.opt.laststatus = 3
vim.opt.linebreak = true
vim.opt.list = false
vim.opt.listchars = {
  tab = ">-",
  trail = "·",
  nbsp = "+",
  extends = "…",
  precedes = "…",
}
vim.opt.backup = true
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.pumblend = 0 -- Popup blend
vim.opt.pumheight = 10 -- Maximum number of entries in a popup
vim.opt.relativenumber = false
vim.opt.report = 0 -- Always report the number of lines changed after :command
vim.opt.scrolloff = 4 -- Lines of context
vim.opt.shiftwidth = 4
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
vim.opt.showbreak = "↳ "
vim.opt.showmode = false -- don't show mode - it's shown in the statusline
vim.opt.sidescrolloff = 8 -- Columns of context
vim.opt.signcolumn = "yes" -- Show sign column, "yes:3" max 3 signs
vim.opt.smartcase = true -- Do not ignore case with capitals
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.softtabstop = -1
vim.opt.splitkeep = "screen"
vim.opt.splitright = true
vim.opt.swapfile = true
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.updatetime = 200 -- For CursorHold and swapfile
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
vim.opt.winminwidth = 5 -- Minimum window width
vim.opt.wrap = false
vim.opt.wrapscan = true

vim.opt.title = false
-- set titlestring to current path, avoid using current buffer options available
-- in statusline since it will cause tmux title to flicker on noice messages
vim.opt.titlestring = "nvim(" .. string.gsub(vim.fn.getenv("PWD"), vim.fn.getenv("HOME"), "~") .. ")"

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

-- directory configuration
vim.opt.viminfo:append("n" .. vim.fn.getenv("HOME") .. "/.local/share/nvim/viminfo")
vim.opt.undodir = vim.fn.getenv("HOME") .. "/.local/share/nvim/undodir//"
vim.opt.backupdir = vim.fn.getenv("HOME") .. "/.local/share/nvim/backup//"
vim.opt.directory = vim.fn.getenv("HOME") .. "/.local/share/nvim/swap//"

-- others
vim.keymap.set("", "<F1>", "<nop>") -- "" == map
vim.keymap.set("!", "<F1>", "<nop>") -- "!" == map!
vim.api.nvim_create_user_command("W", "w", { bang = true })
vim.api.nvim_create_user_command("Q", "q", { bang = true })

-- Use signs for diagnostics in the gutter. By default, neovim uses EWHI.
vim.cmd("sign define DiagnosticSignError text= texthl=DiagnosticSignError")
vim.cmd("sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn")
vim.cmd("sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo")
vim.cmd("sign define DiagnosticSignHint text= texthl=DiagnosticSignHint")
