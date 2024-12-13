{
  lib,
  helpers,
  ...
}:
with lib;
helpers.neovim-plugin.mkNeovimPlugin {
  name = "preview";
  packPathName = "Preview.nvim";
  package = "Preview-nvim";

  hasSettings = false;

  maintainers = [ maintainers.GaetanLepage ];
}
