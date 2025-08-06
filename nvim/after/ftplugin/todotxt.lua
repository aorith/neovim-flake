vim.wo[0][0].spell = true
vim.wo[0][0].number = false
vim.wo[0][0].signcolumn = "auto"

vim.b.minihipatterns_config = {
  highlighters = {
    context = { pattern = "@%w+", group = "Directory" },
    prioA = { pattern = "^%(A%)", group = "ErrorMsg" },
    prioB = { pattern = "^%(B%)", group = "WarningMsg" },
    prioC = { pattern = "^%(C%)", group = "Constant" },
    prioD = { pattern = "^%(D%)", group = "Special" },
    prioE = { pattern = "^%(E%)", group = "Normal" },
  },
}

local insert_new_todo = function()
  local win = vim.api.nvim_get_current_win()
  local row, _ = unpack(vim.api.nvim_win_get_cursor(win))
  local date = os.date("%Y-%m-%d")
  vim.api.nvim_buf_set_lines(0, row, row, false, { "(A) " .. date .. " EDIT_ME @work" })

  local newRow = row + 1
  local newCol = 15

  vim.api.nvim_win_set_cursor(win, { newRow, newCol })
end

local toggle_todo_state = function()
  local node = vim.treesitter.get_node()
  if not node then return end

  local start_row, _ = node:range()
  local line = vim.fn.getline(start_row + 1)
  local pattern = "^x %d%d%d%d%-%d%d%-%d%d "

  if line:match(pattern) then
    line = line:gsub(pattern, "")
  else
    local date = os.date("%Y-%m-%d")
    line = "x " .. date .. " " .. line
  end

  vim.fn.setline(start_row + 1, line)
end

local cycle_priority = function()
  local node = vim.treesitter.get_node()
  if not node then return end

  local start_row, _ = node:range()
  local line = vim.fn.getline(start_row + 1)

  if line:match("^x") then
    vim.notify("Cannot cycle priority of tasks marked as done")
    return
  end

  local current_priority = line:match("^%((%a)%)")

  local priority_map = { A = "(B) ", B = "(C) ", C = "(D) ", D = "(E) ", E = "(A) " }
  local new_priority = priority_map[current_priority] or "(A)"

  if current_priority then
    line = line:gsub("^%(%a%)%s*", new_priority)
  else
    line = new_priority .. " " .. line
  end

  vim.fn.setline(start_row + 1, line)
end

local lmap = function(key, f, desc) vim.keymap.set("n", "<LocalLeader>" .. key, f, { buffer = 0, desc = desc }) end

if vim.fn.expand("%:t") == "done.txt" then
  lmap("s", "<Cmd>w | %sort! | w | lua vim.notify('sorted')<CR>", "Sort reverse")
else
  lmap("s", "<Cmd>w | %sort | w | lua vim.notify('sorted')<CR>", "Sort")
end
lmap("<LocalLeader>", insert_new_todo, "Add todo")
lmap("t", toggle_todo_state, "Toggle todo state")
lmap("p", cycle_priority, "Cycle priority")
