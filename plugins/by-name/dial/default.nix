{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "dial";
  packPathName = "dial.nvim";
  package = "dial-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  # This plugin does not have a conventional setup function
  hasSettings = false;
  callSetup = false;
}
