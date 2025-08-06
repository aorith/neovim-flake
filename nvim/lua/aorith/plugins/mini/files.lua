---@diagnostic disable-next-line: redundant-parameter
require("mini.files").setup({
  -- Module mappings created only inside explorer.
  -- Use `''` (empty string) to not create one.
  mappings = {
    close = "q",
    go_in = "",
    go_in_plus = "<CR>",
    go_out = "-",
    go_out_plus = "",
    reset = "<BS>",
    reveal_cwd = "@",
    show_help = "g?",
    synchronize = "=",
    trim_left = "<",
    trim_right = ">",
  },

  options = {
    permanent_delete = false,
    use_as_default_explorer = true,
  },

  windows = {
    preview = true,
  },
})

-- Toggle hidden files
local show_dotfiles = false
local filter_show = function(_) return true end
local filter_hide = function(fs_entry) return not vim.startswith(fs_entry.name, ".") end
local toggle_dotfiles = function()
  show_dotfiles = not show_dotfiles
  local new_filter = show_dotfiles and filter_show or filter_hide
  require("mini.files").refresh({ content = { filter = new_filter } })
end
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    local buf_id = args.data.buf_id
    vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id })
    vim.keymap.set("n", "<Esc>", MiniFiles.close, { buffer = buf_id })
  end,
})

-- Customize window
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesWindowOpen",
  callback = function(args)
    local win_id = args.data.win_id
    local config = vim.api.nvim_win_get_config(win_id)
    vim.api.nvim_win_set_config(win_id, config)
  end,
})
