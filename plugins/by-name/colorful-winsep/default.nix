{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "colorful-winsep";
  package = "colorful-winsep-nvim";

  maintainers = [ lib.maintainers.saygo-png ];

  settingsExample = {
    highlight = "#b8bb26";
    excluded_ft = [ "NvimTree" ];
    border = [
      "━"
      "┃"
      "┏"
      "┓"
      "┗"
      "┛"
    ];
  };
}
