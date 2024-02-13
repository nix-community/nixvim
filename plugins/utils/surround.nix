{
  config,
  helpers,
  pkgs,
  ...
}:
helpers.vim-plugin.mkVimPlugin config {
  name = "surround";
  originalName = "surround.vim";
  package = pkgs.vimPlugins.surround;
}
