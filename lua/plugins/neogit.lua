--=============================================================================
-------------------------------------------------------------------------------
--                                                                     NVIM-DAP
--=============================================================================
-- https://github.com/TimUntersberger/neogit
--_____________________________________________________________________________

local neogit = require("util.packer.wrapper").get "neogit"

---Setup neogit plugin, add :Git command for neogit
---:Git command is exactly the same as :Neogit
neogit:config(function()
  local mapper = require "util.mapper"

  require("neogit").setup {
    disable_signs = true,
  }

  --NOTE: set :Git as the command for oppening neogit
  --Setup the :Git command exatcly the same as is :Neogit
  mapper.command("Git", function(o)
    local ng = require "neogit"
    ng.open(require("neogit.lib.util").parse_command_args(o.fargs))
  end, {
    nargs = "*",
    desc = "Open Neogit",
    complete = function(arglead)
      local ng = require "neogit"
      return ng.complete(arglead)
    end,
  })
end)
