{ lib, ... }:
let
  name = "blink-cmp-dictionary";
in
lib.nixvim.plugins.mkNeovimPlugin {
  inherit name;

  maintainers = [ lib.maintainers.khaneliman ];

  # Configured through blink-cmp
  callSetup = false;
  hasLuaConfig = false;

  imports = [
    (lib.nixvim.modules.mkBlinkPluginModule {
      pluginName = name;
      # TODO: compute a sane-default key
      key = "dictionary";
      sourceName = "Dict";
      settingsExample = {
        sources.providers = {
          dictionary = {
            score_offset = 100;
            min_keyword_length = 3;
          };
        };
      };
    })
  ];

  settingsExample = lib.literalExpression ''
    {
      # Optional configurations
    }
  '';
}
