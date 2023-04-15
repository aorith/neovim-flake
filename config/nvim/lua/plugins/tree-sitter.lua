require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
    -- TODO: bash treesitter highlights is messed up when it finds something like 'echo >&2 "blah"'
    disable = { "sh", "bash" },
    additional_vim_regex_highlighting = { "sh", "bash" },
  },

  indent = { enable = true, disable = { "python" } },

  -- managed by nix
  ensure_installed = {},
  auto_install = false,
})
