{
  config,
  pkgs,
  helpers,
  ...
}:
helpers.vim-plugin.mkVimPlugin config {
  name = "endwise";
  originalName = "vim-endwise";
  package = pkgs.vimPlugins.vim-endwise;

  # Yes it's really not configurable
  options = {};
}
