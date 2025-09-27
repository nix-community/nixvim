{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "quicker";
  package = "quicker-nvim";
  description = "Improved UI and workflow for the Neovim quickfix.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = import ./settings-options.nix lib;

  settingsExample = {
    keys = [
      {
        __unkeyed-1 = ">";
        __unkeyed-2.__raw = ''
          function()
            require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
          end
        '';
        desc = "Expand quickfix context";
      }
      {
        __unkeyed-1 = "<";
        __unkeyed-2.__raw = "require('quicker').collapse";
        desc = "Collapse quickfix context";
      }
    ];
    edit = {
      enabled = false;
    };
    highlight = {
      load_buffers = false;
    };
  };
}
