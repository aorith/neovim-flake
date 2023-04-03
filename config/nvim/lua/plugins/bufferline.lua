local highlights = {}
if require("core.theme").theme_name() == "catppuccin" then
  highlights = require("catppuccin.groups.integrations.bufferline").get()
end

require("bufferline").setup({
  highlights = highlights,
  options = {
    always_show_bufferline = true,
    separator_style = "slope",
    numbers = "ordinal",
    show_close_icon = false,
    show_buffer_close_icons = false,
    offsets = {
      {
        filetype = "NvimTree",
        text = "NvimTree",
        highlight = "Directory",
        text_align = "left",
      },
      {
        filetype = "neo-tree",
        text = "Neo-tree",
        highlight = "Directory",
        text_align = "left",
      },
    },
  },
})

vim.keymap.set("n", "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", { desc = "Toggle pin" })
vim.keymap.set("n", "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", { desc = "Delete non-pinned buffers" })
vim.keymap.set("n", "<leader><space>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
vim.keymap.set("n", "<leader><TAB>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
