{
  lib,
  helpers,
  pkgs,
  ...
}:
with lib;
helpers.vim-plugin.mkVimPlugin {
  name = "wakatime";
  originalName = "vim-wakatime";
  defaultPackage = pkgs.vimPlugins.vim-wakatime;

  maintainers = [ maintainers.GaetanLepage ];
}
