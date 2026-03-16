vim.bo.shiftwidth = 4
vim.bo.expandtab = true
vim.bo.commentstring = '# %s'

-- Fix comment align
vim.opt_local.cinkeys:remove('0#')
vim.opt_local.indentkeys:remove('0#')
-- Actually, lets just disable cindent
vim.opt_local.cindent = false
vim.opt_local.autoindent = true
