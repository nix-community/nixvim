{
  lib,
  helpers,
  ...
}:
with lib;
lib.nixvim.plugins.mkNeovimPlugin {
  name = "preview";
  packPathName = "Preview.nvim";
  package = "Preview-nvim";

  hasSettings = false;

  maintainers = [ maintainers.GaetanLepage ];
}
