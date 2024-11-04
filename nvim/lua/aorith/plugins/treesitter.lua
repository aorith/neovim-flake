local disabled_files = {
  "Enums.hs",
  "all-packages.nix",
  "hackage-packages.nix",
  "generated.nix",
}

local disabled_filetypes = {
  "bash",
  "dockerfile",
  "sh",
  "tmux",
}

local function disable_treesitter_features(bufnr)
  local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
  local fname = vim.api.nvim_buf_get_name(bufnr)
  local short_name = vim.fn.fnamemodify(fname, ":t")
  return vim.tbl_contains(disabled_files, short_name) or vim.tbl_contains(disabled_filetypes, filetype)
end

local ensure_installed = nvim_nix and {}
  or {
    "bash",
    "c",
    "diff",
    "go",
    "html",
    "lua",
    "luadoc",
    "markdown",
    "markdown_inline",
    "python",
    "query",
    "vim",
    "vimdoc",
  }

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
  auto_install = not nvim_nix,
  ensure_installed = ensure_installed,

  highlight = {
    enable = true,
    disable = function(_, buf)
      if disable_treesitter_features(buf) then
        vim.notify("Treesitter disabled by file/filetype.")
        return true
      end
    end,
    additional_vim_regex_highlighting = { "sh", "bash", "dockerfile", "org" },
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
      set_jumps = false,
      goto_next_start = {
        ["]f"] = { query = "@function.outer", desc = "Next Function outer" },
        ["]c"] = { query = "@class.outer", desc = "Next Class outer" },
      },
      goto_next_end = {
        ["]F"] = { query = "@function.outer", desc = "Next Function outer end" },
        ["]C"] = { query = "@class.outer", desc = "Next Class outer end" },
      },
      goto_previous_start = {
        ["[f"] = { query = "@function.outer", desc = "Prev Function outer" },
        ["[c"] = { query = "@class.outer", desc = "Prev Class outer" },
      },
      goto_previous_end = {
        ["[F"] = { query = "@function.outer", desc = "Prev Function outer end" },
        ["[C"] = { query = "@class.outer", desc = "Prev Class outer end" },
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
})

-- Folds
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
