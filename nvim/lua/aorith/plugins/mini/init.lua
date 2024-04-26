require("aorith.plugins.mini.statusline").setup()
require("aorith.plugins.mini.notify").setup()

require("mini.extra").setup()
require("mini.bufremove").setup()
require("mini.misc").setup()
require("mini.comment").setup()
-- sa => surround around
-- sd => surround delete
-- sr => surround replace
require("mini.surround").setup()

require("aorith.plugins.mini.hipatterns").setup()
require("aorith.plugins.mini.files").setup()
require("aorith.plugins.mini.pick").setup()
require("aorith.plugins.mini.clue").setup()

map("n", "<leader>q", function() MiniBufremove.delete() end, { desc = "Delete current buffer" })
map("n", "<leader>z", function() MiniMisc.zoom() end, { desc = "Zoom window" })
