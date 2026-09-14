_G.Keys = {}

-- NOTE on 'noremap', use it always to avoid recursive mappings, which are only required in rare
-- occasions like chaining to another mapping (e.g. a <Plug> mapping).
-- The following mappings:
--   nnoremap x dd
--   nmap y x
--   nnoremap z x
-- Make 'y' check the mapping of 'x' which is 'dd', so 'y' deletes a line
-- In the case of 'z' it is a noremap so it uses the builtin x mapping (delete char)

--- Sets a keymap with `noremap` and `silent` enabled by default.
---
--- @param mode string|string[] Mode(s) in which the keymap applies (e.g. "n", {"n", "v"})
--- @param lhs string The key sequence to map (e.g. "K")
--- @param rhs function|string The command or function to execute
--- @param desc string Description shown in mini.clue/which-key and hover docs
--- @param opts vim.keymap.set.Opts? Optional override vim.keymap.set options
Keys.map = function(mode, lhs, rhs, desc, opts)
  -- violating `unique=true` throws and error and allows to catch duplicate keymaps
  -- set to false if the keymap is buffer only since those are supposed to overwrite global ones.
  local unique = opts == nil or opts.buf == nil

  local success, _ = pcall(
    vim.keymap.set,
    mode,
    lhs,
    rhs,
    vim.tbl_extend('force', { noremap = true, silent = true, unique = unique }, opts or {}, { desc = desc or nil })
  )
  if success then return end

  local modes = type(mode) == 'table' and table.concat(mode, ', ') or mode
  local msg = ('Duplicate keymap: map=%s | modes=%s'):format(lhs, modes)

  vim.defer_fn(
    function() vim.notify(msg, vim.log.levels.WARN, { title = 'Duplicate Keymap', timeout = false }) end,
    1000
  )
end

--- Sets a keymap prefixed with <leader> and `noremap` and `silent` enabled by default.
---
--- @param mode string|string[] Mode(s) in which the keymap applies (e.g. "n", {"n", "v"})
--- @param lhs string The key sequence to map, without the leader prefix (e.g. "ff")
--- @param rhs function|string The command or function to execute
--- @param desc string Description shown in which-key and hover docs
--- @param opts vim.keymap.set.Opts? Optional additional vim.keymap.set options
Keys.map_leader = function(mode, lhs, rhs, desc, opts) Keys.map(mode, '<leader>' .. lhs, rhs, desc, opts or {}) end

--- Sets a keymap for the current buffer (buf=0) and `noremap` and `silent` enabled by default.
---
--- @param mode string|string[] Mode(s) in which the keymap applies (e.g. "n", {"n", "v"})
--- @param lhs string The key sequence to map, without the leader prefix (e.g. "ff")
--- @param rhs function|string The command or function to execute
--- @param desc string Description shown in mini.clue/which-key and hover docs
--- @param opts vim.keymap.set.Opts? Optional override vim.keymap.set options
Keys.map_buffer = function(mode, lhs, rhs, desc, opts)
  Keys.map(mode, lhs, rhs, desc, vim.tbl_extend('force', { buf = 0 }, opts or {}))
end

---Create an autocommand under a common `aorith-*` augroup.
---@param group_name string
---@param group_opts table? -- see `:h nvim_create_augroup()`
---@param event string|string[]
---@param pattern string|string[]?
---@param callback function
---@param desc string?
_G.NewAutocmd = function(group_name, group_opts, event, pattern, callback, desc)
  local gr = vim.api.nvim_create_augroup('aorith-' .. group_name, group_opts or {})
  local opts = { group = gr, pattern = pattern, callback = callback, desc = desc }
  vim.api.nvim_create_autocmd(event, opts)
end

---Hook into `vim.pack.add()` plugin events. See `:h vim.pack-events`.
---@param plugin_name string
---@param kinds string[] -- eg. { 'install', 'update' }
---@param callback function
---@param desc string?
_G.OnPackChanged = function(plugin_name, kinds, callback, desc)
  local f = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then return end
    if not ev.data.active then vim.cmd.packadd(plugin_name) end
    callback(ev.data)
  end
  _G.NewAutocmd('pack-changed', nil, 'PackChanged', '*', f, desc)
end

---Run `cmd` in a `:terminal` buffer, prompting for one when omitted.
---@param cmd string?
_G.RunInTerminal = function(cmd)
  if cmd == nil or cmd == '' then
    vim.ui.input({ prompt = 'Command to run: ' }, function(input)
      if input and input ~= '' then _G.RunInTerminal(input) end
    end)
    return
  end

  vim.cmd('terminal ' .. cmd)
end

vim.api.nvim_create_user_command(
  'Term',
  function(opts) RunInTerminal(opts.args ~= '' and opts.args or nil) end,
  { nargs = '?', desc = 'Run command in a terminal' }
)
