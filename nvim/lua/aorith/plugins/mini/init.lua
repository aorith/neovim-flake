require("aorith.plugins.mini.statusline").setup()
require("aorith.plugins.mini.notify").setup()

require("mini.extra").setup()
require("mini.bufremove").setup()
require("mini.misc").setup()
require("mini.diff").setup()
require("mini.git").setup()
--require("mini.comment").setup() -- built-in on neovim>=0.10
-- sa => surround around
-- sd => surround delete
-- sr => surround replace
require("mini.surround").setup()
require("mini.icons").setup()
require("mini.align").setup()
MiniIcons.mock_nvim_web_devicons()

require("aorith.plugins.mini.hipatterns").setup()
require("aorith.plugins.mini.files").setup()
require("aorith.plugins.mini.pick").setup()
require("aorith.plugins.mini.clue").setup()
require("aorith.plugins.mini.completion").setup()

require("mini.indentscope").setup()
vim.g.miniindentscope_disable = true -- enable with <leader>ti

map("n", "<leader>q", function() MiniBufremove.delete() end, { desc = "Delete current buffer" })
map("n", "<leader>z", function() MiniMisc.zoom() end, { desc = "Zoom window" })
map("n", "<leader>go", function() MiniDiff.toggle_overlay(0) end, { desc = "Toggle diff overlay" })
