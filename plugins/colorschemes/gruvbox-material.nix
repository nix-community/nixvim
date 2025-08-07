{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "gruvbox-material";
  isColorscheme = true;
  globalPrefix = "gruvbox_material_";

  maintainers = [ lib.maintainers.saygo-png ];

  settingsExample = {
    foreground = "original";
    enable_bold = 1;
    enable_italic = 1;
    transparent_background = 2;
    colors_override = {
      green = [
        "#7d8618"
        142
      ];
    };
    show_eob = 0;
  };
}
