---@diagnostic disable-next-line: redundant-parameter
require("mini.completion").setup({
  set_vim_settings = true,

  delay = { signature = 200 },

  lsp_completion = {
    source_func = "omnifunc",
    auto_setup = false, -- Done manually on 'lsp.lua'
  },
})

vim.o.completeopt = "menuone,noselect,noinsert,popup,fuzzy"

local map_multistep = require("mini.keymap").map_multistep
map_multistep("i", "<Tab>", { "pmenu_next" })
map_multistep("i", "<S-Tab>", { "pmenu_prev" })
map_multistep("i", "<CR>", { "pmenu_accept" })

require("mini.icons").tweak_lsp_kind()
