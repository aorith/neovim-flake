local disabled_files = {
  "Enums.hs",
  "all-packages.nix",
  "hackage-packages.nix",
  "generated.nix",
}

local disabled_filetypes = {
  "tmux",
  "bash",
  "sh",
}

local function disable_treesitter_features(bufnr)
  local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
  local fname = vim.api.nvim_buf_get_name(bufnr)
  local short_name = vim.fn.fnamemodify(fname, ":t")
  return vim.tbl_contains(disabled_files, short_name) or vim.tbl_contains(disabled_filetypes, filetype)
end

local ensure_installed = {
  "bash",
  "c",
  "diff",
  "go",
  "html",
  "javascript",
  "jsdoc",
  "json",
  "jsonc",
  "lua",
  "luadoc",
  "luap",
  "markdown",
  "markdown_inline",
  "printf",
  "python",
  "query",
  "regex",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
}

local opts = {
  auto_install = not My.on_nixos,
  ensure_installed = My.on_nixos and {} or ensure_installed,

  highlight = {
    enable = true,
    disable = function(_, buf)
      if disable_treesitter_features(buf) then
        vim.notify("Treesitter disabled by file/filetype.")
        return true
      end
    end,
    additional_vim_regex_highlighting = disabled_filetypes,
  },

  indent = {
    enable = false, -- Experimental
  },

  textobjects = {
    select = {
      enable = true,

      -- If outside of an object, jump to the next one
      lookahead = true,

      -- For example, 'vaf' would enter visual mode and select the defined @function.outer
      keymaps = {
        ["af"] = { query = "@function.outer", desc = "Function outer" },
        ["if"] = { query = "@function.inner", desc = "Function inner" },
        ["ac"] = { query = "@class.outer", desc = "Class outer" },
        ["ic"] = { query = "@class.inner", desc = "Class inner" },
      },
    },

    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = { query = "@class.outer", desc = "Next class start" },
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = { query = "@class.outer", desc = "Previous class start" },
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<LocalLeader>+",
      node_incremental = "<LocalLeader>+",
      node_decremental = "<LocalLeader>-",
    },
  },
}

require("nvim-treesitter.configs").setup(opts)
require("treesitter-context").setup({
  enable = true,
  max_lines = "15%",
})

-- Folds
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
