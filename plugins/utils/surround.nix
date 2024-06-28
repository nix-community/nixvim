{
  config,
  lib,
  helpers,
  pkgs,
  ...
}:
helpers.vim-plugin.mkVimPlugin config {
  name = "surround";
  originalName = "surround.vim";
  defaultPackage = pkgs.vimPlugins.vim-surround;

  maintainers = [ lib.maintainers.GaetanLepage ];
}
