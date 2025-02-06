{ lib, ... }:
let
  name = "blink-copilot";
in
lib.nixvim.plugins.mkNeovimPlugin {
  inherit name;

  maintainers = [ lib.maintainers.khaneliman ];

  imports = [
    (lib.nixvim.modules.mkBlinkPluginModule {
      pluginName = name;
      # TODO: compute a sane-default
      sourceName = "copilot";
      settingsExample = {
        async = true;
        score_offset = 100;
      };
    })
  ];

  settingsExample = {
    max_completions = 3;
    max_attempts = 4;
    kind = "Copilot";
    debounce = 750;
    auto_refresh = {
      backward = true;
      forward = true;
    };
  };

  # Configured through blink-cmp
  callSetup = false;
  hasLuaConfig = false;

  extraConfig = {
    plugins.copilot-lua.enable = lib.mkDefault true;
  };
}
