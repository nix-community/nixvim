{
  config,
  lib,
  pkgs,
  helpers,
  ...
}:
helpers.vim-plugin.mkVimPlugin config {
  name = "endwise";
  originalName = "vim-endwise";
  defaultPackage = pkgs.vimPlugins.vim-endwise;

  maintainers = [lib.maintainers.GaetanLepage];

  # Yes it's really not configurable
  options = {};
}
