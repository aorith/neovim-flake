local tc = require("telescope")
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")

tc.setup({
  defaults = {
    path_display = {
      "truncate",
    },
    layout_config = {
      width = 0.94,
      height = 0.94,
    },
    file_ignore_patterns = { "venv", "__pycache__", ".git" },
    mappings = {
      i = {
        -- disable if you want to use normal mode in telescope
        --["<esc>"] = function(...) actions.close(...) end,

        ["<C-q>"] = function(...)
          actions.smart_send_to_qflist(...)
          actions.open_qflist(0)
        end,
        ["<C-d>"] = actions.delete_buffer,
      },
      n = {
        ["<C-q>"] = function(...)
          actions.smart_send_to_qflist(...)
          actions.open_qflist(0)
        end,
        ["<C-d>"] = actions.delete_buffer,
        q = actions.close,
      },
    },
  },
})

tc.load_extension("zf-native")

map("n", "<leader>f/", builtin.search_history, { desc = "Search (/) history" })
map("n", "<leader>f:", builtin.command_history, { desc = "Command (:) history" })
map("n", "<leader>fj", builtin.jumplist, { desc = "Jumplist" })

map("n", "<leader><leader>", function() builtin.buffers({ ignore_current_buffer = true }) end, { desc = "Buffers" })

map("n", "<leader>fc", builtin.git_commits, { desc = "Commits (all)" })
map("n", "<leader>fC", builtin.git_bcommits, { desc = "Commits (current)" })
map("v", "<leader>fC", builtin.git_bcommits_range, { desc = "Commits (range)" })

map("n", "<leader>ff", builtin.find_files, { desc = "Files" })
map("n", "<leader>f.", builtin.git_files, { desc = "Find git files" })
map("n", "<leader>fg", builtin.live_grep, { desc = "Grep live" })
map("n", "<leader>fG", builtin.grep_string, { desc = "Grep current word" })

map("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostic workspace" })
map("n", "<leader>fD", function() builtin.diagnostics({ bufnr = 0 }) end, { desc = "Diagnostic buffer" })

map("n", "<leader>fR", builtin.lsp_references, { desc = "References (LSP)" })
map("n", "<leader>fs", builtin.lsp_workspace_symbols, { desc = "Symbols workspace (LSP)" })
map("n", "<leader>fS", builtin.lsp_document_symbols, { desc = "Symbols buffer (LSP)" })
