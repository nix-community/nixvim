{ lib, ... }:
let
  name = "blink-cmp-spell";
in
lib.nixvim.plugins.mkNeovimPlugin {
  inherit name;

  maintainers = [ lib.maintainers.khaneliman ];

  imports = [
    (lib.nixvim.modules.mkBlinkPluginModule {
      pluginName = name;
      # TODO: compute a sane-default
      key = "spell";
      sourceName = "Spell";
      settingsExample = {
        score_offset = 100;
      };
    })
  ];

  # Configured through blink-cmp
  callSetup = false;
  hasLuaConfig = false;
}
