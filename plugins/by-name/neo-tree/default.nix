{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "neo-tree";
  package = "neo-tree-nvim";
  description = "Plugin to manage the file system and other tree like structures.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  # TODO added 2025-10-9 remove after 26.05
  inherit (import ./deprecations.nix lib)
    deprecateExtraOptions
    optionsRenamedToSettings
    imports
    ;

  dependencies = [
    "git"
  ];

  settingsExample = {
    close_if_last_window = true;
    filesystem.follow_current_file = {
      enabled = true;
      leave_dirs_open = true;
    };
  };
}
