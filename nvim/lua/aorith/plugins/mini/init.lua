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
MiniIcons.mock_nvim_web_devicons()

require("aorith.plugins.mini.hipatterns").setup()
require("aorith.plugins.mini.files").setup()
require("aorith.plugins.mini.pick").setup()
require("aorith.plugins.mini.clue").setup()

map("n", "<leader>q", function() MiniBufremove.delete() end, { desc = "Delete current buffer" })
map("n", "<leader>z", function() MiniMisc.zoom() end, { desc = "Zoom window" })
map("n", "<leader>go", function() MiniDiff.toggle_overlay() end, { desc = "Toggle diff overlay" })

require("mini.completion").setup({
  window = {
    info = { height = 25, width = 80, border = "solid" },
    signature = { height = 25, width = 80, border = "solid" },
  },
})
map("i", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true })
map("i", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })
