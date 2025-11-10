{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "fileline";
  package = "fileline-nvim";

  callSetup = false;
  hasSettings = false;

  maintainers = [ lib.maintainers.nim65s ];
}
