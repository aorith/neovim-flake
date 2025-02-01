map(
  "n",
  "-",
  function() require("mini.files").open(vim.api.nvim_buf_get_name(0)) end,
  { desc = "Open parent directory" }
)

local M = {}

M.setup = function()
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

    -- General options
    options = {
      -- Whether to delete permanently or move into module-specific trash
      permanent_delete = false,
      -- Whether to use for editing directories
      use_as_default_explorer = true,
    },

    -- Customization of explorer windows
    windows = {
      -- Maximum number of windows to show side by side
      max_number = 4,
      -- Whether to show preview of file/directory under cursor
      preview = true,
      -- Width of focused window
      width_focus = 50,
      -- Width of non-focused window
      width_nofocus = 15,
      -- Width of preview window
      width_preview = 40,
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
      map("n", "g.", toggle_dotfiles, { buffer = buf_id })
    end,
  })
end

return M
