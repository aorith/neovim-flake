require("toggleterm").setup({
  open_mapping = [[<c-t>]],
  size = 25,
})

local Terminal = require("toggleterm.terminal").Terminal

local gitui = Terminal:new({
  cmd = "gitui",
  close_on_exit = true,
  direction = "float",
  float_opts = {
    width = function()
      return math.floor(vim.o.columns * 0.92)
    end,
    height = function()
      return math.floor(vim.o.lines * 0.92)
    end,
  },
  -- change XDG_CONFIG_HOME so it doesn't point to the nix store
  env = { XDG_CONFIG_HOME = os.getenv("HOME") .. "/.config" },
})

vim.api.nvim_create_user_command("GitUI", function()
  gitui:toggle()
end, { bang = true })

vim.keymap.set("n", "<leader>gu", function()
  vim.cmd.GitUI()
end, { desc = "Git UI" })
