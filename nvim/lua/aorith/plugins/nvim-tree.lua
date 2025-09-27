require("nvim-tree").setup({
  reload_on_bufenter = true,
  sync_root_with_cwd = true,
  diagnostics = {
    enable = false,
  },
  git = {
    enable = false,
  },
  update_focused_file = {
    enable = true,
  },
  view = {
    side = "right",
  },
  renderer = {
    add_trailing = true,
  },
  filters = {
    dotfiles = true,
    git_ignored = false,
  },
})
