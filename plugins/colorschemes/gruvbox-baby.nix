{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "gruvbox-baby";
  maintainers = [ lib.maintainers.saygo-png ];
  isColorscheme = true;

  # Despite being a lua plugin, it's configured via globals without a setup function.
  callSetup = false;
  hasLuaConfig = false;

  settingsExample = {
    function_style = "NONE";
    keyword_style = "italic";
    highlights = {
      Normal = {
        fg = "#123123";
        bg = "NONE";
        style = "underline";
      };
    };
    telescope_theme = 1;
    transparent_mode = 1;
  };

  extraConfig = cfg: {
    globals = lib.nixvim.applyPrefixToAttrs "gruvbox_baby_" cfg.settings;
  };
}
