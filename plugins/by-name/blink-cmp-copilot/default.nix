{ config, lib, ... }:
let
  name = "blink-cmp-copilot";
in
lib.nixvim.plugins.mkNeovimPlugin {
  inherit name;

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  callSetup = false;
  hasLuaConfig = false;

  imports = [
    (lib.nixvim.modules.mkBlinkPluginModule {
      pluginName = name;
      # TODO: compute a sane-default source name
      sourceName = "copilot";
      settingsExample = {
        async = true;
        score_offset = 100;
      };
    })
  ];

  settingsExample = {
    max_completions = 3;
  };

  extraConfig = {
    warnings =
      let
        copilot-lua-cfg = config.plugins.copilot-lua.settings;
      in
      lib.nixvim.mkWarnings "plugins.blink-cmp-copilot" [
        {
          when = copilot-lua-cfg.suggestion.enabled == true;
          message = ''
            It is recommended to disable copilot's `suggestion` module, as it can interfere with
            completions properly appearing in blink-cmp-copilot.
          '';
        }
        {
          when = copilot-lua-cfg.panel.enabled == true;
          message = ''
            It is recommended to disable copilot's `panel` module, as it can interfere with completions
            properly appearing in blink-cmp-copilot.
          '';
        }
      ];

    plugins.copilot-lua.enable = lib.mkDefault true;
  };
}
