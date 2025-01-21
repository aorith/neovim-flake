return function()
  local path_package = vim.fn.stdpath("data") .. "/site"
  local mini_path = path_package .. "/pack/deps/start/mini.nvim"
  if not (vim.uv or vim.loop).fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    local clone_cmd = {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/echasnovski/mini.nvim",
      mini_path,
    }
    vim.fn.system(clone_cmd)
    vim.cmd("packadd mini.nvim") -- adding ' | helptags ALL' breaks it
    vim.cmd('echo "Installed `mini.nvim`" | redraw')
  end

  -- initialize mini.deps
  -- Commands start with 'Deps*'
  require("mini.deps").setup({ path = { package = path_package } })
  local add, now = MiniDeps.add, MiniDeps.now

  -- Using MiniDeps.now so the errors are shown in the notifications instead of in the messages
  now(function()
    add({
      source = "MunifTanjim/nui.nvim",
      checkout = "main",
      depends = { "nvim-lua/plenary.nvim" },
    })

    add({
      source = "nvim-treesitter/nvim-treesitter",
      -- Use 'master' while monitoring updates in 'main'
      checkout = "master",
      monitor = "main",
      -- Perform action after every checkout
      hooks = { post_checkout = function() vim.cmd("TSUpdate") end },
    })

    add({
      source = "nvim-treesitter/nvim-treesitter-textobjects",
      depends = {
        "nvim-treesitter/nvim-treesitter",
      },
    })

    add({
      source = "neovim/nvim-lspconfig",
      depends = {
        "folke/lazydev.nvim",
      },
    })

    add({
      source = "L3MON4D3/LuaSnip",
      hooks = {
        post_install = function(args)
          vim.system({ "make", "-C", args.path, "install_jsregexp" }, { text = true }):wait()
        end,
        post_checkout = function(args)
          vim.system({ "make", "-C", args.path, "install_jsregexp" }, { text = true }):wait()
        end,
      },
    })

    add({ source = "stevearc/conform.nvim", checkout = "v8.0.0", monitor = "master" })
    add({ source = "mfussenegger/nvim-lint", checkout = "master" })
    add({ source = "nvim-neo-tree/neo-tree.nvim", checkout = "3.26", monitor = "main" })
    add({ source = "stevearc/aerial.nvim", checkout = "master" })
    add({ source = "varnishcache-friends/vim-varnish", checkout = "main" })
    add({ source = "tpope/vim-sleuth" })
    add({ source = "mbbill/undotree" })
    add({ source = "sindrets/diffview.nvim" })
    add({ source = "nvim-treesitter/nvim-treesitter-context" })
  end)

  -- Load the configuration
  now(function()
    require("aorith.plugins.theme")

    require("aorith.core.options")
    require("aorith.core.autocmds")
    require("aorith.core.keymaps")

    require("aorith.plugins.mini")

    require("aorith.plugins.treesitter")
    require("aorith.plugins.lsp")

    require("aorith.plugins.linting")
    require("aorith.plugins.formatting")

    require("aorith.plugins.neotree")
    require("aorith.plugins.aerial")
  end)
end
