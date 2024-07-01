{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
helpers.neovim-plugin.mkNeovimPlugin config {
  name = "preview";
  originalName = "Preview.nvim";
  defaultPackage = pkgs.vimPlugins.Preview-nvim;

  hasSettings = false;

  maintainers = [ maintainers.GaetanLepage ];
}
