{ lib, ... }:
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "flutter-tools";
  packPathName = "flutter-tools.nvim";
  package = "flutter-tools-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsOptions = {
  };
}
