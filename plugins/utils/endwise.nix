{
  config,
  pkgs,
  helpers,
  ...
}:
helpers.vim-plugin.mkVimPlugin config {
  name = "endwise";
  originalName = "vim-endwise";
  defaultPackage = pkgs.vimPlugins.vim-endwise;

  # Yes it's really not configurable
  options = {};
}
