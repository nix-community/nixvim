{
  config,
  helpers,
  pkgs,
  ...
}:
helpers.vim-plugin.mkVimPlugin config {
  name = "surround";
  description = "surround.vim";
  package = pkgs.vimPlugins.surround;

  options = {};
}
