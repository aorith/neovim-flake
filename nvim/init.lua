vim.loader.enable()
_G.map = vim.keymap.set

require("aorith.core.options")
require("aorith.core.autocmds")
require("aorith.core.keymaps")
