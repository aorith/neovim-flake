vim.bo.shiftwidth = 4
vim.bo.expandtab = true
vim.bo.commentstring = '# %s'

-- Fix comment align (comments starting with '#' do not indent after pressing '>' without this)
vim.opt_local.cindent = true
vim.opt_local.cinkeys:remove('0#')
