{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "teamtype";

  maintainers = [ lib.maintainers.GaetanLepage ];

  callSetup = false;
  hasSettings = false;
}
