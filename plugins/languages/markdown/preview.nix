{
  lib,
  helpers,
  pkgs,
  ...
}:
with lib;
helpers.neovim-plugin.mkNeovimPlugin {
  name = "preview";
  originalName = "Preview.nvim";
  defaultPackage = pkgs.vimPlugins.Preview-nvim;

  hasSettings = false;

  maintainers = [ maintainers.GaetanLepage ];
}
