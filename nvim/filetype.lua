-- Bigfile (https://github.com/folke/snacks.nvim/blob/e937bfaa741c4ac7379026b09ec252bd7a9409a6/lua/snacks/bigfile.lua#L19C1-L32C5)
-- Registered first so it takes precedence over the patterns below.
-- The matching `FileType` handler lives in 'plugin/01_autocmds.lua'.
vim.filetype.add({
  pattern = {
    ['.*'] = {
      function(path, buf)
        return vim.bo[buf]
            and vim.bo[buf].filetype ~= 'bigfile'
            and path
            and vim.fn.getfsize(path) > Config.bigfile_size
            and 'bigfile'
          or nil
      end,
    },
  },
})

vim.filetype.add({
  pattern = {
    ['.*html.j2'] = 'htmldjango',
    ['.*html.jinja'] = 'htmldjango',
    ['.*html.jinja2'] = 'htmldjango',

    -- [".*.html"] = function(path, bufnr)
    --   local result = -1
    --   vim.api.nvim_buf_call(bufnr, function() result = vim.fn.search("end }}") end)
    --   if result > 0 then return "gohtmltmpl" end
    --   return "html"
    -- end,

    ['.*container'] = 'systemd',
    ['.*tofu'] = 'terraform',
    ['todo.txt'] = 'todotxt',
    ['done.txt'] = 'todotxt',

    -- ansible
    ['.*/host_vars/.*%.ya?ml'] = 'yaml.ansible',
    ['.*/group_vars/.*%.ya?ml'] = 'yaml.ansible',
    ['.*/group_vars/.*/.*%.ya?ml'] = 'yaml.ansible',
    ['.*/playbook.*%.ya?ml'] = 'yaml.ansible',
    ['.*/playbooks/.*%.ya?ml'] = 'yaml.ansible',
    ['.*/roles/.*/tasks/.*%.ya?ml'] = 'yaml.ansible',
    ['.*/roles/.*/handlers/.*%.ya?ml'] = 'yaml.ansible',
    ['.*/tasks/.*%.ya?ml'] = 'yaml.ansible',
    ['.*/molecule/.*%.ya?ml'] = 'yaml.ansible',
  },
})
