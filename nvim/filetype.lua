vim.filetype.add({
  pattern = {
    [".*html.j2"] = "htmldjango",
    [".*html.jinja"] = "htmldjango",
    [".*html.jinja2"] = "htmldjango",

    -- [".*.html"] = function(path, bufnr)
    --   local result = -1
    --   vim.api.nvim_buf_call(bufnr, function() result = vim.fn.search("end }}") end)
    --   if result > 0 then return "gohtmltmpl" end
    --   return "html"
    -- end,

    [".*container"] = "systemd",

    -- ansible
    [".*/host_vars/.*%.ya?ml"] = "yaml.ansible",
    [".*/group_vars/.*%.ya?ml"] = "yaml.ansible",
    [".*/group_vars/.*/.*%.ya?ml"] = "yaml.ansible",
    [".*/playbook.*%.ya?ml"] = "yaml.ansible",
    [".*/playbooks/.*%.ya?ml"] = "yaml.ansible",
    [".*/roles/.*/tasks/.*%.ya?ml"] = "yaml.ansible",
    [".*/roles/.*/handlers/.*%.ya?ml"] = "yaml.ansible",
    [".*/tasks/.*%.ya?ml"] = "yaml.ansible",
    [".*/molecule/.*%.ya?ml"] = "yaml.ansible",
  },
})
