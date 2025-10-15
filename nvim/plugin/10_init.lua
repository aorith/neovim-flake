--- Mini nvim
-------------------------------------------------------------------------------
local add, later = MiniDeps.add, MiniDeps.later
local now_if_args = vim.fn.argc(-1) > 0 and MiniDeps.now or later

add({ name = "mini.nvim" })

-- nvim should detect terminal features and enable this automatically, but
-- the combination of tmux + ssh + nixos leaves this disabled
vim.o.termguicolors = true
-- colorscheme
vim.cmd("colorscheme miniwinter")

require("aorith.plugins.mini.basics")
require("aorith.plugins.mini.notify")
require("mini.tabline").setup()
require("aorith.plugins.mini.statusline")
require("mini.extra").setup()
require("mini.diff").setup({ view = { style = "sign" } })
require("aorith.plugins.mini.git")
require("aorith.plugins.mini.files")
require("aorith.plugins.mini.hipatterns")
require("aorith.plugins.mini.pick")

require("mini.icons").setup()
later(require("mini.icons").mock_nvim_web_devicons)
later(require("mini.icons").tweak_lsp_kind)

later(function()
  require("mini.misc").setup({ make_global = { "put", "put_text" } })
  -- MiniMisc.setup_auto_root()
  -- MiniMisc.setup_termbg_sync()
end)
later(function() require("mini.ai").setup() end) -- Enables 'ciq' (change inside quotes) or 'cib' (change inside brackets), etc.
later(function() require("mini.bufremove").setup() end)
-- later(require("mini.cursorword").setup)
later(function() require("aorith.plugins.mini.indentscope") end)
-- sa => surround around
-- sd => surround delete
-- sr => surround replace
-- Example: Visual select a word -> sa"  (surround around quotes, 'saq' with mini.ai)
later(function() require("mini.surround").setup() end)
later(function() require("mini.visits").setup() end)
later(function() require("mini.trailspace").setup({ only_in_normal_buffers = true }) end)
later(function() require("aorith.plugins.mini.clue") end)
later(function() require("aorith.plugins.mini.completion") end)
later(function() require("mini.jump").setup({ delay = { highlight = 50 } }) end)
later(
  -- Press CR to start jumping
  function() require("mini.jump2d").setup({ labels = "abcdefghijklmnopqrstu1234vwxyz", allowed_lines = { blank = false, cursor_at = false, fold = false } }) end
)
later(function() require("aorith.plugins.mini.snippets") end)

--- Plugins
-------------------------------------------------------------------------------
add({ source = "tpope/vim-sleuth" })
add({ source = "b0o/SchemaStore.nvim" })

now_if_args(function()
  if not Config.on_nix then
    -- Treesitter
    add({
      source = "nvim-treesitter/nvim-treesitter",
      checkout = "main",
      hooks = { post_checkout = function() vim.cmd("TSUpdate") end },
    })
    add({ source = "nvim-treesitter/nvim-treesitter-context", checkout = "master" })
    add({ source = "nvim-treesitter/nvim-treesitter-textobjects", checkout = "main" })

    -- Other plugins packaged at nix/plugins.nix
    add({ source = "varnishcache-friends/vim-varnish" })
  end

  require("aorith.plugins.treesitter")
end)

-- Nvim-Lspconfig
now_if_args(function()
  add({ source = "neovim/nvim-lspconfig" })
  require("aorith.plugins.lsp")
end)

-- Formatting
later(function()
  add({ source = "stevearc/conform.nvim" })
  require("aorith.plugins.formatting")
end)

-- Linting
later(function()
  add({ source = "mfussenegger/nvim-lint" })
  require("aorith.plugins.linting")
end)

-- Outline
later(function()
  add({ source = "hedyhli/outline.nvim" })
  require("aorith.plugins.outline")
end)

-- Nvim Dap
later(function()
  add({ source = "mfussenegger/nvim-dap" })
  add({ source = "miroshQa/debugmaster.nvim" })
  add({ source = "theHamsta/nvim-dap-virtual-text" })
  add({ source = "mfussenegger/nvim-dap-python" })
  require("aorith.plugins.dap")
end)

-- Quicker nvim
later(function()
  add({ source = "stevearc/quicker.nvim" })
  require("quicker").setup()
end)
