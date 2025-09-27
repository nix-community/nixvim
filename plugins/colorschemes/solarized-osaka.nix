{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "solarized-osaka";
  isColorscheme = true;
  package = "solarized-osaka-nvim";
  colorscheme = "solarized-osaka";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    transparent = false;
    styles = {
      comments.italic = true;
      keywords.italic = false;
      floats = "transparent";
    };
  };
}
