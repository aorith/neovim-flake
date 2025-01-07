-- https://neovim.discourse.group/t/dynamically-changing-settings-block-for-lsp/2589

local M = {}

M.current_yaml_schema = "No YAML schema"
M.custom_schemas = {}

M.get_client = function()
  M.bufnr = vim.api.nvim_get_current_buf()
  M.uri = vim.uri_from_bufnr(M.bufnr)
  if vim.bo.filetype ~= "yaml" then return end
  if not M.client then M.client = vim.lsp.get_clients({ name = "yamlls", bufnr = M.bufnr })[1] end
  return M.client
end

M._load_all_schemas = function()
  local client = M.get_client()
  if not client then return end
  local params = { uri = M.uri }
  client.request("yaml/get/all/jsonSchemas", params, function(err, result, _, _)
    if err then return end
    if result then
      if client.settings.yaml.custom_schemas then
        M.custom_schemas = client.settings.yaml.custom_schemas
        for key, name in pairs(client.settings.yaml.custom_schemas) do
          table.insert(result, { uri = key, name = name })
        end
      end
      if vim.tbl_count(result) == 0 then return vim.notify("Schemas not loaded yet.") end
      M._open_ui_select(result)
    end
  end)
end

M._change_settings = function(schema)
  if not schema then return end
  local client = M.get_client()
  if not client then return end
  local previous_settings = client.settings
  for key, value in pairs(previous_settings.yaml.schemas) do
    if vim.islist(value) then
      for idx, value_value in pairs(value) do
        if value_value == M.uri or string.find(value_value, "*") then
          table.remove(previous_settings.yaml.schemas[key], idx)
        end
      end
    elseif value == M.uri or string.find(value, "*") then
      previous_settings.yaml.schemas[key] = nil
    end
  end

  client.settings = vim.tbl_deep_extend("force", previous_settings, {
    yaml = {
      schemas = {
        [schema.uri] = M.uri,
      },
    },
  })
  client.notify("workspace/didChangeConfiguration")
  vim.notify("Successfully applied schema " .. M._display_schema_item(schema))
end

M._display_schema_item = function(schema) return schema.name or schema.uri end

M._open_ui_select = function(schemas)
  vim.ui.select(schemas, { format_item = M._display_schema_item, prompt = "Select YAML Schema" }, M._change_settings)
end

M.select = function()
  M.get_client()
  if not M.client then return end
  M._load_all_schemas()
end

M._save_current_schema = function(schema)
  if M.custom_schemas[schema] then
    schema = M.custom_schemas[schema]
  elseif schema ~= nil then
    schema = schema:gsub("https://raw.githubusercontent.com/", "")
    schema = schema:gsub("https://json.schemastore.org/", "")
  end
  if schema then M.current_yaml_schema = "YAML schema: " .. schema end

  return M.current_yaml_schema
end

M.get_current_schema_async = function()
  local client = M._get_client()
  if not M.client or not M.uri then return "" end
  client.request("yaml/get/jsonSchema", { M.uri }, function(err, e)
    local current_schema
    if err then return end
    if e[1] ~= nil then
      if e[1].name then
        current_schema = e[1].name
      else
        current_schema = e[1].uri
      end
    end
    M._save_current_schema(current_schema)
  end)

  return M.current_yaml_schema
end

M.get_current_schema = function()
  local client = M.get_client()
  if not client then return "" end
  local response, err = client.request_sync("yaml/get/jsonSchema", { vim.uri_from_bufnr(0) }, 1000, 0)

  local current_schema
  if err or not response or not response.result then return end

  if response.result[1] ~= nil then
    if response.result[1].name then
      current_schema = response.result[1].name
    else
      current_schema = response.result[1].uri
    end
  end

  M._save_current_schema(current_schema)
  return M.current_yaml_schema
end

return M
