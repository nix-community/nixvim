{
  lib,
  helpers,
  ...
}:
with lib;
helpers.neovim-plugin.mkNeovimPlugin {
  name = "preview";
  originalName = "Preview.nvim";
  package = "Preview-nvim";

  hasSettings = false;

  maintainers = [ maintainers.GaetanLepage ];
}
