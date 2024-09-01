{
  lib,
  helpers,
  pkgs,
  ...
}:
helpers.vim-plugin.mkVimPlugin {
  name = "surround";
  originalName = "surround.vim";
  defaultPackage = pkgs.vimPlugins.vim-surround;

  maintainers = [ lib.maintainers.GaetanLepage ];
}
