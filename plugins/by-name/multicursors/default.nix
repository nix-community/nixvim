{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "multicursors";
  package = "multicursors-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsExample = {
    DEBUG_MODE = true;
    create_commands = false;
    normal_keys = {
      "," = {
        method = lib.nixvim.mkRaw "require('multicursors.normal_mode').clear_others";
        opts = {
          desc = "Clear others";
        };
      };
    };
    hint_config = {
      type = "cmdline";
      position = "top";
    };
  };

  # TODO: Deprecated 2025-10-04
  inherit (import ./deprecations.nix lib)
    imports
    optionsRenamedToSettings
    deprecateExtraOptions
    ;
}
