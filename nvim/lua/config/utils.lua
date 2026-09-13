---@class MyConfig.Keymap : vim.keymap.set.Opts
---@field [1] string -- lhs
---@field [2] string|function -- rhs
---@field mode? string|string[] -- defaults to "n"
---@field ft? string|string[] -- set keymap only for these filetypes

---Warn when there are conflicting keymaps & use API similar to lazy.nvim keymaps
---@param map MyConfig.Keymap
_G.Keymap = function(map)
  local mode = map.mode or 'n'
  local lhs, rhs = map[1], map[2]
  local opts = vim.deepcopy(map)
  opts.ft, opts.mode, opts[1], opts[2] = nil, nil, nil, nil

  local caller = debug.getinfo(2, 'Sl') -- S: source, l: currentline
  local source = vim.fs.basename(caller.source) .. ':' .. caller.currentline

  if map[3] then
    vim.defer_fn(function()
      local msg = ('%s  **%s**'):format(lhs, source)
      vim.notify(msg, vim.log.levels.WARN, { title = 'Keymap with 3 args', timeout = false })
    end, 1000)
    return
  end

  if not map.ft then
    -- GLOBAL keymap
    -- 1. allow to disable with `unique=false` to overwrite nvim defaults
    -- 2. do not set `unique` for buffer-specific maps, since they are supposed
    --    to overwrite global ones
    if opts.unique == nil and opts.buf == nil then opts.unique = true end

    -- violating `unique=true` throws an error; using `pcall` to still load other mappings
    local success, _ = pcall(vim.keymap.set, mode, lhs, rhs, opts)
    if success then return end

    local modes = type(mode) == 'table' and table.concat(mode, ', ') or mode
    local msg = ('`(%s)`  %s  **%s**'):format(modes, lhs, source)

    vim.defer_fn(function() -- defer for notification plugin
      vim.notify(msg, vim.log.levels.WARN, { title = 'Duplicate keymap', timeout = false })
    end, 1000)
  else
    -- FILETYPE keymap
    vim.api.nvim_create_autocmd('FileType', {
      desc = 'User: plugin filetype-keymap',
      pattern = map.ft,
      callback = function(ctx)
        opts.buf = ctx.buf
        vim.keymap.set(mode, lhs, rhs, opts)
      end,
    })
  end
end

---@param map MyConfig.Keymap
_G.Bufmap = function(map)
  map.buf = 0
  Keymap(map)
end

---@param map MyConfig.Keymap
_G.Leadermap = function(map)
  map[1] = '<Leader>' .. map[1]
  Keymap(map)
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
