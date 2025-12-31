{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "iswap";
  package = "iswap-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    debug = true;
    move_cursor = true;
  };
}
