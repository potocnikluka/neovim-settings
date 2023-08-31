--=============================================================================
-------------------------------------------------------------------------------
--                                                               NVIM-LSPCONFIG
--[[===========================================================================
https://github.com/neovim/nvim-lspconfig
https://github.com/creativenull/efmls-configs-nvim

Keymaps:
  - "K"         -  Show the definition of symbol under the cursor
  - "<C-k>"     -  Show the diagnostics of the line under the cursor
  - "<leader>r" -  Rename symbol under cursor

  - "<leader>f" - format the current buffer
-----------------------------------------------------------------------------]]
local M = {
  "neovim/nvim-lspconfig",
  cmd = { "LspStart", "LspInfo" },
  dependencies = {
    "creativenull/efmls-configs-nvim",
  },
}

local open_diagnostic_float
local configure_vim_diagnostic
local on_lsp_attach
local format

function M.init()
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      vim.schedule(function() on_lsp_attach(args) end)
    end,
  })

  configure_vim_diagnostic()

  vim.keymap.set("n", "<leader>f", format)
  vim.keymap.set("v", "<leader>f", function() format(true) end)
end

function on_lsp_attach(args)
  if
    not type(args.buf) == "number" or not vim.api.nvim_buf_is_valid(args.buf)
  then
    return
  end
  local opts = { buffer = args.buf }
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<C-k>", open_diagnostic_float, opts)
  -- NOTE: the lsp definitions and references are used with telescope.nvim
  -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  -- vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
end

function open_diagnostic_float()
  local n, _ = vim.diagnostic.open_float()
  if not n then Util.log("LSP"):warn("No diagnostics found") end
end

function configure_vim_diagnostic()
  local border = "single"
  vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, {
      border = border,
    })

  vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = border,
    })
  vim.diagnostic.config({
    float = { border = border },
    virtual_text = true,
    underline = { severity = "Error" },
    severity_sort = true,
  })
end

local attach_language_server
local update_efm_server

---@diagnostic disable-next-line: duplicate-set-field
Util.__lsp().__attach = function(opts, filetype)
  local lspconfig = Util.require("lspconfig")
  if not lspconfig then return end
  local c =
    Util.require("lspconfig.server_configurations." .. opts.name, nil, true)
  local name = opts.name
  if c == nil then
    opts.name = "efm"
    opts.languages = {
      [filetype] = { name },
    }
    return update_efm_server(lspconfig, opts)
  end
  return attach_language_server(lspconfig, opts)
end

function attach_language_server(lspconfig, server)
  local lsp = lspconfig[server.name]
  if lsp == nil then
    Util.log("LSP"):warn("Language server not found:", server.name)
    return false
  end

  server = vim.tbl_deep_extend(
    "force",
    server or {},
    vim.g[server.name .. "_config"] or {}
  )
  lsp.setup(server)
  vim.api.nvim_exec2("LspStart", {})
  return true
end

local efm_rootmarkers = { ".git/" }
local efm_languages = {}

local formatters = {}

function update_efm_server(lspconfig, opts)
  local languages = opts.languages
  if type(opts.settings) ~= "table" then opts.settings = {} end
  if type(languages) ~= "table" then
    if type(languages) ~= "table" then
      Util.log("LSP"):warn("Invalid config for efm:", opts)
      return false
    end
  end
  if not lspconfig then return end
  for k, v in pairs(languages) do
    if type(v) ~= "table" then
      Util.log("LSP"):warn("Invalid config for efm:", opts)
      return false
    end
    for k2, v2 in pairs(v) do
      if type(v2) ~= "string" then
        Util.log("LSP"):warn("Invalid config for efm:", opts)
        return false
      end
      local m = Util.require("efmls-configs.formatters." .. v2, nil, true)
      if not m then
        m = Util.require("efmls-configs.linters." .. v2, nil, true)
      else
        if formatters[k] ~= nil then
          Util.log("LSP"):warn("Formatter already exists for", k)
          return
        end
        formatters[k] = v2
      end
      if not m then
        Util.log("LSP")
          :warn("No matching formatters and linters found for:", v2)
        return false
      end
      m.name = v2
      v[k2] = m
    end
  end
  if type(opts.init_options) ~= "table" then opts.init_options = {} end
  opts.init_options.documentFormatting = true
  opts.init_options.documentRangeFormatting = true
  opts.capabilities = nil

  for k, l in pairs(languages) do
    for _, v in pairs(l) do
      efm_languages[k] = efm_languages[k] or {}
      table.insert(efm_languages[k], v)
    end
  end
  for _, k in ipairs(opts.settings.rootMarkers or {}) do
    if type(k) == "string" and not vim.tbl_contains(efm_rootmarkers, k) then
      table.insert(efm_rootmarkers, k)
    end
  end
  opts.settings.languages = languages
  for k, v in pairs(efm_languages) do
    if opts.settings.languages[k] == nil then
      opts.settings.languages[k] = {}
    end
    for _, v2 in pairs(v) do
      table.insert(opts.settings.languages[k], v2)
    end
  end
  opts.filetypes = vim.tbl_keys(opts.settings.languages)

  opts.autostart = true
  lspconfig.efm.setup(opts)
  vim.api.nvim_exec2("LspStart efm", {})
  return true
end

function format(visual)
  local filter = function(client)
    if client.name ~= "efm" then
      return false or type(client.config) ~= "table"
    end
    local c = client.config
    if
      type(c.languages) ~= "table"
      or type(c.languages[vim.bo.filetype]) ~= "table"
    then
      return false
    end
    local available = formatters[vim.bo.filetype]
    if type(available) ~= "string" then return end
    for _, v in pairs(c.languages[vim.bo.filetype]) do
      if v.name == available then
        Util.log("LSP"):debug("Formatting with:", available)
        return true
      end
    end
    return false
  end

  local range = nil
  if visual then
    local start_row, _ = unpack(vim.api.nvim_buf_get_mark(0, "<"))
    local end_row, _ = unpack(vim.api.nvim_buf_get_mark(0, ">"))
    range = {
      ["start"] = { start_row, 0 },
      ["end"] = { end_row, 0 },
    }
  end
  vim.lsp.buf.format({
    async = false,
    range = range,
    filter = filter,
  })
end

return M
