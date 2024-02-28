local M = {}

M.setup = function()
  local win_config = function()
    local height = math.floor(0.8 * vim.o.lines)
    local width = math.floor(0.92 * vim.o.columns)
    return {
      border = "double",
      anchor = "NW",
      height = height,
      width = width,
      row = math.floor(0.5 * (vim.o.lines - height)),
      col = math.floor(0.5 * (vim.o.columns - width)),
    }
  end

  require("mini.pick").setup({
    mappings = {
      choose = "<CR>",
      choose_in_split = "<C-s>",
      choose_in_tabpage = "<C-t>",
      choose_in_vsplit = "<C-v>",
      choose_marked = "<C-q>",
    },
    window = {
      prompt_prefix = "❯ ",
      config = win_config,
    },
  })
  vim.ui.select = MiniPick.ui_select

  MiniPick.registry.notes = function(local_opts)
    local opts = { source = { cwd = notes_dir } }
    return MiniPick.builtin.files(local_opts, opts)
  end
  MiniPick.registry.notes_grep = function(local_opts)
    local opts = { source = { cwd = notes_dir } }
    return MiniPick.builtin.grep_live(local_opts, opts)
  end

  map("n", "<leader>f/", [[<Cmd>Pick history scope='/'<CR>]], { desc = '"/" history' })
  map("n", "<leader>f:", [[<Cmd>Pick history scope=':'<CR>]], { desc = '":" history' })
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
  map("n", "<leader>fR", [[<Cmd>Pick lsp scope='references'<CR>]], { desc = "References (LSP)" })
  map("n", "<leader>fs", [[<Cmd>Pick lsp scope='workspace_symbol'<CR>]], { desc = "Symbols workspace (LSP)" })
  map("n", "<leader>fS", [[<Cmd>Pick lsp scope='document_symbol'<CR>]], { desc = "Symbols buffer (LSP)" })
  map("n", "<leader>fv", [[<Cmd>Pick visit_paths cwd=''<CR>]], { desc = "Visit paths (all)" })
  map("n", "<leader>fV", [[<Cmd>Pick visit_paths<CR>]], { desc = "Visit paths (cwd)" })
end

return M
