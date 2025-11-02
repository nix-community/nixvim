{ lib, config, ... }:
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

  extraConfig = cfg: {
    warnings = lib.nixvim.mkWarnings "colorschemes.gruvbox-material" {
      when = (cfg.settings.better_performance or 0 == 1) && !config.impureRtp;
      message = ''
        You have enabled 'better_performance', but the top-level option 'impureRtp' is false.
        The performance option generates syntax files at runtime that cannot be accessed with impureRtp disabled.
        This breaks the plugin. Either disable 'better_performance' or enable 'impureRtp'.
      '';
    };
  };
}
