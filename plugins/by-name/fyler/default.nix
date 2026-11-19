{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "fyler";
  package = "fyler-nvim";
  description = "A neovim file manager which can edit file system like a buffer with tree view";

  maintainers = [ lib.maintainers.qacow37 ];

  settingsExample = {
    auto_confirm_simple_mutation = false;
    bound_cursor = true;
    follow_current_file = true;

    kind = "replace";
    kind_presets = {
      replace = {
        mappings = {
          n = {
            "<CR>" = {
              action = "select";
              args = {
                close = true;
                pick = false;
              };
            };
          };
        };
      };
    };

    mappings = {
      n = {
        "<C-R>" = {
          action = "refresh";
          args = {
            recursive = true;
            force = true;
          };
          desc = "Force refresh the tree";
        };
        "<C-S>" = {
          action = "select";
          args = {
            split = true;
          };
          desc = "Open in horizontal split";
        };
      };
    };
  };
}
