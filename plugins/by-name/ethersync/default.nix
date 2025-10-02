{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "ethersync";

  maintainers = [ lib.maintainers.GaetanLepage ];

  callSetup = false;
  hasSettings = false;
}
