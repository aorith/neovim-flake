require("bufferline").setup({
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
