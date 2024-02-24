require("mini.extra").setup()
require("mini.bufremove").setup()
require("mini.misc").setup()
require("mini.comment").setup()
-- sa => surround around
-- sd => surround delete
-- sr => surround replace
require("mini.surround").setup()

map("n", "<leader>q", function() MiniBufremove.delete() end, { desc = "Delete current buffer" })
map("n", "<leader>z", function() MiniMisc.zoom() end, { desc = "Zoom window" })
