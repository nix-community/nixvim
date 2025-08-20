{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  moduleName = "contextfiles";
  name = "contextfiles";
  package = "contextfiles-nvim";

  callSetup = false;
  hasLuaConfig = false;
  hasSettings = false;

  maintainers = with lib.maintainers; [
    c4patino
  ];
}
