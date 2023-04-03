vim.g.neo_tree_remove_legacy_commands = 1

require("neo-tree").setup({
  close_if_last_window = false,
  enable_diagnostics = false,
  filesystem = {
    bind_to_cwd = false,
    follow_current_file = true,
  },
  default_component_configs = {
    name = {
      trailing_slash = true,
      use_git_status_colors = false,
    },
    indent = {
      with_expanders = true,
    },
  },
  window = {
    mappings = {
      ["<space>"] = "none",
    },
  },
  event_handlers = {
    {
      event = "file_opened",
      handler = function(file_path)
        --auto close
        require("neo-tree").close_all()
      end,
    },
  },
})

vim.keymap.set("n", "<leader>e", function()
  require("neo-tree.command").execute({ toggle = true, position = "left" })
end, { desc = "NeoTree" })
