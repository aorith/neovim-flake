-- use as a pager, etc
vim.cmd("syntax off")

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.o.number = true
vim.o.ruler = true
vim.o.scrolloff = 3
vim.o.sidescrolloff = 3
vim.o.cursorlineopt = "number"
vim.o.wrap = true
vim.o.lazyredraw = true

vim.o.list = true
vim.o.listchars = table.concat({ "extends:…", "trail:·", "nbsp:␣", "precedes:…", "tab:> " }, ",")

vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.smartcase = true

vim.o.shell = "bash"
vim.o.modelineexpr = false
vim.o.backup = false
vim.o.writebackup = false
vim.o.mouse = "a"
vim.o.undofile = false

vim.o.clipboard = "unnamedplus"

vim.keymap.set("", "<F1>", "<nop>")
vim.keymap.set("!", "<F1>", "<nop>")
vim.keymap.set("n", "q", ":qa!<CR>")
vim.api.nvim_create_user_command("W", "w", { bang = true })
vim.api.nvim_create_user_command("Q", "q", { bang = true })

vim.o.rulerformat = "%30(%l,%c/%L %p%%%= [%b 0x%B] %)"
