{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "colorful-menu";
  packPathName = "colorful-menu.nvim";
  package = "colorful-menu-nvim";

  maintainers = [ lib.maintainers.khaneliman ];
}
