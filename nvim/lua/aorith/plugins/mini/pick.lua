---@diagnostic disable-next-line: redundant-parameter
require("mini.pick").setup({
  mappings = {
    choose = "<CR>",
    choose_in_split = "<C-s>",
    choose_in_tabpage = "<C-t>",
    choose_in_vsplit = "<C-v>",

    choose_marked = "<C-q>",
    mark = "<C-x>",
    mark_all = "<C-a>",
  },
})

vim.ui.select = MiniPick.ui_select

MiniPick.registry.notes = function(local_opts)
  vim.fn.chdir(My.notes_dir)
  local opts = { source = { cwd = My.notes_dir } }
  return MiniPick.builtin.files(local_opts, opts)
end

MiniPick.registry.notes_grep = function(local_opts)
  vim.fn.chdir(My.notes_dir)
  local opts = { source = { cwd = My.notes_dir } }
  return MiniPick.builtin.grep_live(local_opts, opts)
end
