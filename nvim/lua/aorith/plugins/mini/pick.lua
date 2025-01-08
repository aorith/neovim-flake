local M = {}

M.setup = function()
  local win_config = function()
    local width = vim.o.columns - 8
    local has_tabline = vim.o.showtabline == 2 or (vim.o.showtabline == 1 and #vim.api.nvim_list_tabpages() > 1)
    local has_statusline = vim.o.laststatus > 0
    local max_height = vim.o.lines - vim.o.cmdheight - (has_tabline and 1 or 0) - (has_statusline and 1 or 0)
    return {
      height = math.floor(0.8 * max_height),
      width = width,
      row = max_height + (has_tabline and 1 or 0),
      col = 1,
    }
  end

  ---@diagnostic disable-next-line: redundant-parameter
  require("mini.pick").setup({
    mappings = {
      choose = "<CR>",
      choose_in_split = "<C-s>",
      choose_in_tabpage = "<C-t>",
      choose_in_vsplit = "<C-v>",

      choose_marked = "<C-q>",
      mark = "<C-x>",
      mark_all = "<C-a>",
    },
    window = {
      config = win_config,
    },
  })
  vim.ui.select = MiniPick.ui_select

  map("n", "<leader>fa", [[<Cmd>Pick git_hunks scope='staged'<CR>]], { desc = "Added hunks (all)" })
  map("n", "<leader>fA", [[<Cmd>Pick git_hunks path='%' scope='staged'<CR>]], { desc = "Added hunks (current)" })
  map("n", "<leader><leader>", [[<Cmd>Pick buffers include_current=false<CR>]], { desc = "Buffers" })
  map("n", "<leader>fc", [[<Cmd>Pick git_commits<CR>]], { desc = "Commits (all)" })
  map("n", "<leader>fC", [[<Cmd>Pick git_commits path='%'<CR>]], { desc = "Commits (current)" })
  map("n", "<leader>fd", [[<Cmd>Pick diagnostic scope='all'<CR>]], { desc = "Diagnostic workspace" })
  map("n", "<leader>fD", [[<Cmd>Pick diagnostic scope='current'<CR>]], { desc = "Diagnostic buffer" })
  map("n", "<leader>ff", [[<Cmd>Pick files<CR>]], { desc = "Files" })
  map("n", "<leader>fg", [[<Cmd>Pick grep_live<CR>]], { desc = "Grep live" })
  map("n", "<leader>fG", [[<Cmd>Pick grep pattern='<cword>'<CR>]], { desc = "Grep current word" })
  map("n", "<leader>fh", [[<Cmd>Pick help<CR>]], { desc = "Help tags" })
  map("n", "<leader>fH", [[<Cmd>Pick hl_groups<CR>]], { desc = "Highlight groups" })
  map("n", "<leader>fl", [[<Cmd>Pick buf_lines scope='all'<CR>]], { desc = "Lines (all)" })
  map("n", "<leader>f,", [[<Cmd>Pick buf_lines scope='current'<CR>]], { desc = "Lines (current)" })
  map("n", "<leader>fm", [[<Cmd>Pick git_hunks<CR>]], { desc = "Modified hunks (all)" })
  map("n", "<leader>fM", [[<Cmd>Pick git_hunks path='%'<CR>]], { desc = "Modified hunks (current)" })
  map("n", "<leader>fr", [[<Cmd>Pick resume<CR>]], { desc = "Resume" })
  map("n", "<leader>fs", [[<Cmd>Pick lsp scope='workspace_symbol'<CR>]], { desc = "Symbols workspace (LSP)" })
  map("n", "<leader>fS", [[<Cmd>Pick lsp scope='document_symbol'<CR>]], { desc = "Symbols buffer (LSP)" })
  map("n", "<leader>fp", [[<Cmd>Pick spellsuggest<CR>]], { desc = "Spell suggest" })
  map("n", "<leader>fk", [[<Cmd>Pick keymaps<CR>]], { desc = "Keymaps" })

  -- without leader key
  map("n", "gr", "<Cmd>Pick lsp scope='references'<CR>", { desc = "[G]oto [R]eferences" })
  map("n", "gd", "<Cmd>Pick lsp scope='definition'<CR>", { desc = "[G]oto [D]definition" })
  map("n", "gD", "<Cmd>Pick lsp scope='declaration'<CR>", { desc = "[G]oto [D]eclaration" })
end

return M
