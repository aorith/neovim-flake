--- Mini nvim
-------------------------------------------------------------------------------
local add, later = MiniDeps.add, MiniDeps.later

add({ name = 'mini.nvim' })

-- nvim should detect terminal features and enable this automatically, but
-- the combination of tmux + ssh + nixos leaves this disabled
if not vim.o.termguicolors then vim.o.termguicolors = true end

-- require('mini.tabline').setup()
require('mini.extra').setup()
require('mini.diff').setup()

require('mini.icons').setup()
later(require('mini.icons').mock_nvim_web_devicons)
later(require('mini.icons').tweak_lsp_kind)

require('mini.misc').setup({ make_global = { 'put', 'put_text' } })
-- MiniMisc.setup_auto_root()
-- MiniMisc.setup_termbg_sync()

later(function() require('mini.ai').setup() end) -- Enables 'ciq' (change inside quotes) or 'cib' (change inside brackets), etc.
later(function() require('mini.bufremove').setup() end)
-- later(require("mini.cursorword").setup)
-- sa => surround around
-- sd => surround delete
-- sr => surround replace
-- Example: Visual select a word -> sa"  (surround around quotes, 'saq' with mini.ai)
later(function() require('mini.surround').setup() end)
later(function() require('mini.visits').setup() end)
later(function() require('mini.trailspace').setup({ only_in_normal_buffers = true }) end)
later(function() require('mini.jump').setup({ delay = { highlight = 50 } }) end)
later(
  -- Press CR to start jumping
  function()
    require('mini.jump2d').setup({
      labels = 'abcdefghijklmnopqrstu1234vwxyz',
      allowed_lines = { blank = false, cursor_at = false, fold = false },
    })
  end
)

--- Plugins
-------------------------------------------------------------------------------
add({ source = 'tpope/vim-sleuth' })
add({ source = 'b0o/SchemaStore.nvim' })
add({ source = 'varnishcache-friends/vim-varnish' })

if not Config.on_nix then
  -- Treesitter
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'main',
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })
  add({ source = 'nvim-treesitter/nvim-treesitter-context', checkout = 'master' })
  add({ source = 'nvim-treesitter/nvim-treesitter-textobjects', checkout = 'main' })
end

-- Nvim-Lspconfig
add({ source = 'neovim/nvim-lspconfig' })

-- Formatting
add({ source = 'stevearc/conform.nvim' })

-- Linting
add({ source = 'mfussenegger/nvim-lint' })

-- Outline
add({ source = 'hedyhli/outline.nvim' })

-- Quicker nvim
later(function()
  add({ source = 'stevearc/quicker.nvim' })
  require('quicker').setup()
end)

-- colorscheme
vim.cmd.colorscheme('miniautumn')
