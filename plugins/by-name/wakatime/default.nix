{
  lib,
  helpers,
  ...
}:
with lib;
lib.nixvim.vim-plugin.mkVimPlugin {
  name = "wakatime";
  packPathName = "vim-wakatime";
  package = "vim-wakatime";

  maintainers = [ maintainers.GaetanLepage ];
}
