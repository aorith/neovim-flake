require("telescope").setup({
  defaults = {
    layout_strategy = "horizontal",

    layout_config = {
      vertical = {
        height = 0.9,
        width = 0.9,
        preview_width = 0.60,
      },
      horizontal = {
        height = 0.9,
        width = 0.9,
        preview_width = 0.60,
      },
    },

    file_ignore_patterns = { "venv", "__pycache__", ".git" },
    mappings = {
      i = {
        ["<c-t>"] = function(...)
          return require("trouble.providers.telescope").open_with_trouble(...)
        end,
        -- disable if you want to use normal mode
        ["<esc>"] = function(...)
          require("telescope.actions").close(...)
        end,
      },
      n = {
        ["q"] = function(...)
          return require("telescope.actions").close(...)
        end,
      },
    },
  },
})

require("telescope").load_extension("fzf")
require("telescope").load_extension("manix")

--- keymaps
vim.keymap.set("n", "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", { desc = "Switch Buffer" })

vim.keymap.set("n", "<leader>:", "<cmd>Telescope command_history<cr>", { desc = "Command History" })
-- find
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find Files" })
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Grep ALL" })
-- git
vim.keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "commits" })
vim.keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "status" })
-- search
vim.keymap.set("n", "<leader>/", function()
  require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 5,
    previewer = false,
  }))
end, {
  desc = "Search current buffer",
})

vim.keymap.set("n", "<leader>sf", "<cmd>Telescope find_files<cr>", { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sd", "<cmd>Telescope diagnostics<cr>", { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sh", "<cmd>Telescope help_tags<cr>", { desc = "[S]earch [H]elp Pages" })
vim.keymap.set("n", "<leader>sw", "<cmd>Telescope grep_string<cr>", { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", "<cmd>Telescope live_grep<CR>", { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sG", "<cmd>Telescope git_files<CR>", { desc = "[S]earch [G]it Files" })

-- extras
vim.keymap.set("n", "<leader>seC", "<cmd>Telescope commands<cr>", { desc = "Commands" })
vim.keymap.set("n", "<leader>seH", "<cmd>Telescope highlights<cr>", { desc = "Search Highlight Groups" })
vim.keymap.set("n", "<leader>sek", "<cmd>Telescope keymaps<cr>", { desc = "Key Maps" })
vim.keymap.set("n", "<leader>sea", "<cmd>Telescope autocommands<cr>", { desc = "Auto Commands" })
vim.keymap.set("n", "<leader>seo", "<cmd>Telescope vim_options<cr>", { desc = "Options" })
vim.keymap.set("n", "<leader>sem", "<cmd>Telescope marks<cr>", { desc = "Jump to Mark" })
vim.keymap.set("n", "<leader>seM", "<cmd>Telescope man_pages<cr>", { desc = "Man Pages" })
vim.keymap.set("n", "<leader>ses", function()
  require("telescope.builtin").lsp_document_symbols({
    symbols = {
      "Class",
      "Function",
      "Method",
      "Constructor",
      "Interface",
      "Module",
      "Struct",
      "Trait",
      "Field",
      "Property",
    },
  })
end, {
  desc = "Goto Symbol",
})

vim.keymap.set("n", "<leader>uC", function()
  require("telescope.builtin").colorscheme({ enable_preview = true })
end, {
  desc = "Colorscheme with preview",
})
