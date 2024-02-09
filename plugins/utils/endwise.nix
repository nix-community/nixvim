{
  config,
  pkgs,
  helpers,
  ...
}:
helpers.vim-plugin.mkVimPlugin config {
  name = "endwise";
  description = "vim-endwise";
  package = pkgs.vimPlugins.vim-endwise;

  # Yes it's really not configurable
  options = {};
}
