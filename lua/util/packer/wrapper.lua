local plugins = {}

---@class Plugin
---@field name string: The name of the plugin, should match 'as' field in packer config.
local Plugin = {
  ---@type table: Metadata for the workspace plugin.
  ---@class PluginMetadata
  ---@field loaded boolean: Whether the plugin is loaded.
  ---@field disabled boolean: Whether the plugin is disabled.
  ---@field after_load_functions table: Functions to run after loading the plugin.
  ---@field data table: A table for custom actions.
  __meta = {data={}},
  __plugins = {}
}
Plugin.__index = Plugin
---Returns the Plugin object for the given plugin name.
---
---Note that the Packer.nvim's plugin config should be wrapped
---with `workspace.plugin.new` function, otherwise this will
---return nil.
---
---Example:
---<code>
---  local lspconfig = packer_wrapper.get("lspconfig")
---</code>
---
---@param name string: The name of the plugin.
---@return Plugin: The Plugin object for the given plugin name.
function Plugin.get(name)
  if plugins[name] == nil then
    local plugin = {name=name, __meta = {data={}}}
    setmetatable(plugin, Plugin)
    plugins[name] = plugin
  end
  return plugins[name]
end


---Adds a field to the plugin object.
---It may be then fetched with `Plugin:get_field(k)`
---
---@param k string: field's key
---@param v any: field's value
function Plugin:add_field(k, v)
  self.__meta.data[k] = v
end

---Fetch the field created with `Plugin:add_field(k, v)`
---
---@return any
function Plugin:get_field(k)
  return self.__meta.data[k]
end

local plugin_after_load

---This is a wrapper function for the Packer.nvim's use function,
---that created a new Plugin object that handles the plugin's
---config functions and enablement.
---
---Note, using this will disable packer.nvim's `config` field
---for the plugin.
---
---If a lua 'plugins.plugin_name' exists, it will be loaded.
---
---Example:
---
---<code>
---  packer.startup(function(use)
---    use "wbthomason/packer.nvim"
---    use "lpoto/workspace.nvim"
---    packer_wrapper.new(use, {
---      "neovim/nvim-lspconfig",
---      as = "lspconfig",
---    }, 'plugins.lspconfig')
---  end)
---</code>
---
---@param use function?: Packer.nvim's use function (may be nill for sub-plugins).
---@param packer_config table: Packer.nvim's plugin config.
function Plugin.new(use, packer_config)
  local log = require "util.log"

  if packer_config.as == nil then
    log.warn "Plugin config should have an 'as' field"
    return
  end

  local plugin = Plugin.get(packer_config.as)

  packer_config.config = plugin_after_load()

  packer_config.cond = "require('util.packer.wrapper').get('"
    .. plugin.name
    .. "'):enabled()"

  if packer_config.requires ~= nil then
    for _, v in ipairs(packer_config.requires) do
      if type(v) == "table" and v.as ~= nil then
        Plugin.new(nil, v)
      end
    end
  end

  if use ~= nil then
    local ok, e = pcall(use, packer_config)
    if ok == false then
      log.warn("Error when creating " .. plugin.name .. " plugin: " .. e)
    end
  end

  plugin:__load_module()
end

---Adds a function that is called after the plugin is loaded.
---This does not override other config functions.
---Optionally the key can be provided, so the plugin's config functions
---may be filtered with `Plugin:filter_config`.
---
---Example that configures `pylsp` server after the lspconfig plugin is loaded:
---<code>
---  local lspconfig = packer_wrapper.get('lspconfig')
---  lspconfig:config(function()
---    require('lspconfig').pylsp.setup{}
---  end)
---</code>
---
---NOTE: in the example above the key is not provided, so it will be `nil`.
---This is relevant for the `Plugin:filter_config` function,
---as the `nil` keys are also considered.
---
---@param config function: The function to call after the plugin is loaded.
---@param key string?: Optional key to identify the config function.
function Plugin:config(config, key)
  local log = require "util.log"

  if self.__meta.loaded == true then
    local ok, e = pcall(config)
    if ok == false then
      log.warn(e)
    end
    return
  end
  local o = {
    f = config,
    key = key,
  }
  if self.__meta.after_load_functions == nil then
    self.__meta.after_load_functions = {}
  end
  table.insert(self.__meta.after_load_functions, o)
end

---Marks the plugin as disabled.
---Note that the Packer.nvim's plugin config should be wrapped
---with the `workspace.plugin.new` function.
function Plugin:disable()
  self.__meta.disabled = true
end

---Returns true if the plugin is enabled, false otherwise.
function Plugin:enabled()
  return self.__meta.disabled ~= true
end

---Filters the plugin's config functions with the provided function,
---that recieves a config function's key as an argument
---and returns a boolean. The functions that were removed will
---not be called after the plugin is loaded.
---
---Note that the keys may also be nil.
---
---Example that removes all configs with keys equal to 'pylsp':
---<code>
---  local lspconfig = packer_wrapper.get('lspconfig')
---  lspconfig:filter_config(function(key)
---    return key ~= "pylsp"
---  end)
---</code>
---
---@param filter function: The filter function
function Plugin:filter_config(filter)
  local log = require "util.log"

  if self.__meta.after_load_functions == nil then
    return
  end

  local ok, e = pcall(vim.tbl_filter, function(o)
    return filter(o.key)
  end, self.__meta.after_load_functions)

  if ok == false then
    log.warn(e)
  else
    self.__meta.after_load_functions = e
  end
end

plugin_after_load = function()
  return function(name)
    local log = require "util.log"
    local p = require("util.packer.wrapper").get(name)

    if p.__meta.after_load_functions ~= nil then
      for _, o in ipairs(p.__meta.after_load_functions) do
        local ok, e = pcall(o.f)
        if ok == false then
          log.warn(e)
        end
      end
       p.__meta.after_load_functions = nil
    end
    p.__meta.loaded = true
  end
end

function Plugin:__load_module()
    local module = "plugins." .. self.name
    if package.loaded[module] == nil then
      pcall(require, module)
    end
end

return Plugin
