{
  lib,
  pkgs,
  helpers,
  ...
}:
helpers.vim-plugin.mkVimPlugin {
  name = "endwise";
  originalName = "vim-endwise";
  defaultPackage = pkgs.vimPlugins.vim-endwise;

  maintainers = [ lib.maintainers.GaetanLepage ];

  # This plugin has no config options
}
