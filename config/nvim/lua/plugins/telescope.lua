local tc = require("telescope")
local tcb = require("telescope.builtin")
local tct = require("telescope.themes")

tc.setup({
  defaults = {
    file_ignore_patterns = { "venv", "__pycache__", ".git" },
    mappings = {
      i = {
        -- disable if you want to use normal mode in telescope
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

tc.load_extension("fzf")
tc.load_extension("manix")

--- keymaps
vim.keymap.set("n", "<leader><space>", function()
  tcb.buffers(tct.get_dropdown({ layout_config = { width = 0.8 } }))
end, { desc = "Switch Buffer" })

vim.keymap.set("n", "<leader>:", "<cmd>Telescope command_history<cr>", { desc = "Command History" })
-- find
vim.keymap.set("n", "<leader>ff", function()
  tcb.find_files()
end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Grep ALL" })
vim.keymap.set("n", "<leader>fG", function()
  tcb.live_grep({ grep_open_files = true })
end, { desc = "Grep open files" })
vim.keymap.set("n", "<leader>fw", "<cmd>Telescope grep_string<cr>", { desc = "Find current word" })
-- git
vim.keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "commits" })
vim.keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "status" })
-- search
vim.keymap.set("n", "<leader>/", function()
  tcb.current_buffer_fuzzy_find({ skip_empty_lines = true })
end, {
  desc = "Search current buffer",
})

vim.keymap.set("n", "<leader>sd", "<cmd>Telescope diagnostics<cr>", { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>sh", "<cmd>Telescope help_tags<cr>", { desc = "Vim Help" })
vim.keymap.set("n", "<leader>sG", "<cmd>Telescope git_files<CR>", { desc = "Git files" })

-- extras
vim.keymap.set("n", "<leader>seC", "<cmd>Telescope commands<cr>", { desc = "Commands" })
vim.keymap.set("n", "<leader>seH", "<cmd>Telescope highlights<cr>", { desc = "Search Highlight Groups" })
vim.keymap.set("n", "<leader>sek", "<cmd>Telescope keymaps<cr>", { desc = "Key Maps" })
vim.keymap.set("n", "<leader>sea", "<cmd>Telescope autocommands<cr>", { desc = "Auto Commands" })
vim.keymap.set("n", "<leader>seo", "<cmd>Telescope vim_options<cr>", { desc = "Options" })

vim.keymap.set("n", "<leader>uc", function()
  tcb.colorscheme({ enable_preview = true })
end, {
  desc = "Colorscheme with preview",
})
