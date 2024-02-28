vim.loader.enable()
_G.map = vim.keymap.set

require("aorith.core.options")
require("aorith.core.autocmds")
require("aorith.core.keymaps")

require("aorith.plugins.mini")
require("aorith.plugins.neotree")
require("aorith.plugins.statuscol")
require("aorith.plugins.trouble")
require("aorith.plugins.telescope")
require("aorith.plugins.treesitter")
require("aorith.plugins.lsp")
require("aorith.plugins.linting")
require("aorith.plugins.formatting")
require("aorith.plugins.completion")
require("aorith.plugins.gitsigns")

require("aorith.plugins.theme")
