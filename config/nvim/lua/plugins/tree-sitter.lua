require("nvim-treesitter.configs").setup({
  highlight = { enable = true, disable = {}, additional_vim_regex_highlighting = {} },
  indent = { enable = true, disable = { "python" } },

  -- managed by nix
  ensure_installed = {},
  auto_install = false,
})
