{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "dracula-nvim";
  moduleName = "dracula";
  colorscheme = "dracula";
  isColorscheme = true;

  maintainers = [ lib.maintainers.refaelsh ];

  settingsExample = {
    italic_comment = true;
    colors.green = "#00FF00";
  };
}
