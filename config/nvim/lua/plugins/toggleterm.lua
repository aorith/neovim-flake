require("toggleterm").setup({
  open_mapping = [[<c-t>]],
  size = 25,
})

local Terminal = require("toggleterm.terminal").Terminal

local lazygit = Terminal:new({
  cmd = "lazygit",
  close_on_exit = true,
  direction = "float",
  float_opts = {
    width = function()
      return math.floor(vim.o.columns * 0.95)
    end,
    height = function()
      return math.floor(vim.o.lines * 0.95)
    end,
  },
  -- fix XDG_CONFIG_HOME because of the neovim flake
  env = { XDG_CONFIG_HOME = os.getenv("HOME") .. "/.config" },
})

vim.api.nvim_create_user_command("LazyGit", function()
  lazygit:toggle()
end, { bang = true })

vim.keymap.set("n", "<leader>gl", function()
  vim.cmd.LazyGit()
end, { desc = "LazyGit" })
