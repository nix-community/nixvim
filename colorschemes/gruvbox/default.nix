{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "gruvbox";
  isColorscheme = true;
  package = "gruvbox-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    terminal_colors = true;
    palette_overrides = {
      dark1 = "#323232";
      dark2 = "#383330";
      dark3 = "#323232";
      bright_blue = "#5476b2";
      bright_purple = "#fb4934";
    };
  };
}
