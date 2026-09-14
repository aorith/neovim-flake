require('mini.diff').setup({ view = { style = 'sign' } })

local MiniGit = require('mini.git')
MiniGit.setup({ command = { split = 'vertical' } })

local align_blame = function(au_data)
  if au_data.data.git_subcommand ~= 'blame' then return end

  -- Align blame output with source
  local win_src = au_data.data.win_source
  vim.wo.wrap = false
  vim.fn.winrestview({ topline = vim.fn.line('w0', win_src) })
  vim.api.nvim_win_set_cursor(0, { vim.fn.line('.', win_src), 0 })

  -- Bind both windows so that they scroll together
  vim.wo[win_src].scrollbind, vim.wo.scrollbind = true, true
end

NewAutocmd('mini-git-align-blame', nil, 'User', 'MiniGitCommandSplit', align_blame)

local git_log_cmd = [[Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order]]
local git_reflog_cmd = [[Git log --abbrev-commit --walk-reflogs --pretty=format:\%h\ \%ai\ \%al\ |\ \%s\ |\ \%d]] -- similar to 'git reflog'
local git_graph_cmd = [[Git log --graph --all --pretty=format:\%h\ \%ai\ \%al\ |\ \%s\ |\ \%d]]
Keys.map_leader('n', 'gp', '<Cmd>Git log -p -- %:p<CR>', 'Git log -p <file>')
Keys.map_leader('n', 'ga', '<Cmd>Git diff --cached -- %:p<CR>', 'Added diff buffer')
Keys.map_leader('n', 'gA', '<Cmd>Git diff --cached<CR>', 'Added diff')
Keys.map_leader('n', 'gd', '<Cmd>Git diff -- %:p<CR>', 'Diff buffer')
Keys.map_leader('n', 'gD', '<Cmd>Git diff<CR>', 'Diff')
Keys.map_leader('n', 'gb', '<Cmd>Git blame -- %:p<CR>', 'Blame buffer')
Keys.map_leader('n', 'gl', '<Cmd>' .. git_log_cmd .. ' --follow -- %:p<CR>', 'Log buffer')
Keys.map_leader('n', 'gL', '<Cmd>' .. git_log_cmd .. '<CR>', 'Log')
Keys.map_leader('n', 'gr', '<Cmd>tab ' .. git_reflog_cmd .. '<CR>', 'Reflog')
Keys.map_leader('n', 'gg', '<Cmd>tab ' .. git_graph_cmd .. '<CR>', 'Graph')
Keys.map_leader('n', 'go', '<Cmd>lua MiniDiff.toggle_overlay()<CR>', 'Toggle diff overlay')
Keys.map_leader('n', 'gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>', 'Show at cursor')

-- Show at cursor already gives info from show_range_history
Keys.map_leader('x', 'gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>', 'Show at selection')
Keys.map_leader(
  'x',
  'gb',
  function() vim.cmd('Git log -L ' .. vim.fn.line("'<") .. ',' .. vim.fn.line("'>") .. ':' .. vim.fn.expand('%:p')) end,
  'Blame selection'
)
