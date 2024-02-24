local disabled_files = {
  "Enums.hs",
  "all-packages.nix",
  "hackage-packages.nix",
  "generated.nix",
}

local disabled_filetypes = {
  "sh",
  "bash",
  "dockerfile",
}

local function disable_treesitter_features(bufnr)
  local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
  local fname = vim.api.nvim_buf_get_name(bufnr)
  local short_name = vim.fn.fnamemodify(fname, ":t")
  return vim.tbl_contains(disabled_files, short_name) or vim.tbl_contains(disabled_filetypes, filetype)
end

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
  auto_install = false,

  highlight = {
    enable = true,
    disable = function(_, buf)
      if disable_treesitter_features(buf) then
        vim.notify("Treesitter disabled by file/filetype.")
        return true
      end
      local fname = vim.api.nvim_buf_get_name(buf)
      local max_filesize = 100 * 1024 -- 100 KiB
      local ok, stats = pcall(vim.loop.fs_stat, fname)
      if ok and stats and stats.size > max_filesize then
        vim.notify("Treesitter disabled by filesize.")
        return true
      end
    end,
    additional_vim_regex_highlighting = { "sh", "bash", "dockerfile", "org" },
  },

  indent = {
    enable = true,
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

-- Headlines
require("headlines").setup({
  markdown = {
    headline_highlights = false,
    fat_headlines = false,
  },
  norg = {
    headline_highlights = false,
  },
})
