{
  config,
  helpers,
  pkgs,
  ...
}:
helpers.vim-plugin.mkVimPlugin config {
  name = "surround";
  originalName = "surround.vim";
  defaultPackage = pkgs.vimPlugins.surround;
}
