{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "nvchad-ui";
  description = "UI component modules from NvChad for standalone Neovim setups.";

  maintainers = [ lib.maintainers.khaneliman ];

  callSetup = false;
  hasSettings = false;
}
