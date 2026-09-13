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
Leadermap({ 'gp', '<Cmd>Git log -p -- %:p<CR>', desc = 'Git log -p <file>' })
Leadermap({ 'ga', '<Cmd>Git diff --cached -- %:p<CR>', desc = 'Added diff buffer' })
Leadermap({ 'gA', '<Cmd>Git diff --cached<CR>', desc = 'Added diff' })
Leadermap({ 'gd', '<Cmd>Git diff -- %:p<CR>', desc = 'Diff buffer' })
Leadermap({ 'gD', '<Cmd>Git diff<CR>', desc = 'Diff' })
Leadermap({ 'gb', '<Cmd>Git blame -- %:p<CR>', desc = 'Blame buffer' })
Leadermap({ 'gl', '<Cmd>' .. git_log_cmd .. ' --follow -- %:p<CR>', desc = 'Log buffer' })
Leadermap({ 'gL', '<Cmd>' .. git_log_cmd .. '<CR>', desc = 'Log' })
Leadermap({ 'gr', '<Cmd>tab ' .. git_reflog_cmd .. '<CR>', desc = 'Reflog' })
Leadermap({ 'gg', '<Cmd>tab ' .. git_graph_cmd .. '<CR>', desc = 'Graph' })
Leadermap({ 'go', '<Cmd>lua MiniDiff.toggle_overlay()<CR>', desc = 'Toggle diff overlay' })
Leadermap({ 'gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>', desc = 'Show at cursor' })
Leadermap({ 'gc', '<Cmd>Pick git_commits path="%:p"<CR>', desc = '[Pick] Commits (current)' })
Leadermap({ 'gC', '<Cmd>Pick git_commits<CR>', desc = '[Pick] Commits (all)' })

-- Show at cursor already gives info from show_range_history
Leadermap({ 'gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>', mode = 'x', desc = 'Show at selection' })
Leadermap({
  'gb',
  function() vim.cmd('Git log -L ' .. vim.fn.line("'<") .. ',' .. vim.fn.line("'>") .. ':' .. vim.fn.expand('%:p')) end,
  mode = 'x',
  desc = 'Blame selection',
})
