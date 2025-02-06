{ lib, ... }:
let
  name = "blink-cmp-git";
in
lib.nixvim.plugins.mkNeovimPlugin {
  inherit name;

  maintainers = [ lib.maintainers.khaneliman ];

  imports = [
    (lib.nixvim.modules.mkBlinkPluginModule {
      pluginName = name;
      # TODO: compute a sane-default
      sourceName = "git";
      settingsExample = {
        score_offset = 100;
      };
    })
  ];

  settingsExample = {
    commit = { };
    git_centers = {
      git_hub = { };
    };
  };

  # Configured through blink-cmp
  callSetup = false;
  hasLuaConfig = false;
}
