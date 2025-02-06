{ lib, ... }:
let
  name = "blink-emoji";
in
lib.nixvim.plugins.mkNeovimPlugin {
  inherit name;
  packPathName = "blink-emoji.nvim";
  package = "blink-emoji-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  imports = [
    (lib.nixvim.modules.mkBlinkPluginModule {
      pluginName = name;
      # TODO: compute a sane-default
      key = "emoji";
      sourceName = "Emoji";
      module = "blink-emoji";
      settingsExample = {
        score_offset = 15;
      };
    })
  ];

  settingsExample = {
    insert = true;
  };

  # Configured through blink-cmp
  callSetup = false;
  hasLuaConfig = false;
}
