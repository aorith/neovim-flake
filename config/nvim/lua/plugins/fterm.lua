local fterm = require("FTerm")
fterm.setup({
  dimensions = {
    height = 1,
    width = 1,
  },
})

local lazygit = fterm:new({
  cmd = "lazygit",
  auto_close = true,
  dimensions = { height = 1, width = 1 },
  -- fix XDG_CONFIG_HOME because of the neovim flake
  env = { XDG_CONFIG_HOME = os.getenv("HOME") .. "/.config" },
})

vim.api.nvim_create_user_command("LazyGit", function()
  lazygit:toggle()
end, { bang = true })

vim.keymap.set("n", "<leader>t", function()
  require("FTerm").toggle()
end, { desc = "Toggle Term" })

vim.keymap.set("n", "<leader>gl", function()
  require("FTerm")
  vim.cmd.LazyGit()
end, { desc = "LazyGit" })
