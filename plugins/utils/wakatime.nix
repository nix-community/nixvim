{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
helpers.vim-plugin.mkVimPlugin config {
  name = "wakatime";
  originalName = "vim-wakatime";
  defaultPackage = pkgs.vimPlugins.vim-wakatime;

  maintainers = [ maintainers.GaetanLepage ];
}
