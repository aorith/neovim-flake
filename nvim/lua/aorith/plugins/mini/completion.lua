local M = {}

M.setup = function()
  require("mini.completion").setup({
    window = {
      info = { height = 25, width = 80, border = "solid" },
      signature = { height = 25, width = 80, border = "solid" },
    },
  })

  map("i", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true })
  map("i", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })

  -- More consistent behavior of `<CR>`
  local keys = {
    ["cr"] = vim.keycode("<CR>"),
    ["ctrl-y"] = vim.keycode("<C-y>"),
    ["ctrl-y_cr"] = vim.keycode("<C-y><CR>"),
  }

  _G.cr_action = function()
    if vim.fn.pumvisible() ~= 0 then
      -- If popup is visible, confirm selected item or add new line otherwise
      local item_selected = vim.fn.complete_info()["selected"] ~= -1
      return item_selected and keys["ctrl-y"] or keys["ctrl-y_cr"]
    else
      -- If popup is not visible, use plain `<CR>`. You might want to customize
      -- according to other plugins. For example, to use 'mini.pairs', replace
      -- next line with `return require('mini.pairs').cr()`
      return keys["cr"]
    end
  end

  map("i", "<CR>", "v:lua._G.cr_action()", { expr = true })
end

return M
