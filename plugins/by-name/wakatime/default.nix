{
  lib,
  helpers,
  ...
}:
with lib;
lib.nixvim.plugins.mkVimPlugin {
  name = "wakatime";
  packPathName = "vim-wakatime";
  package = "vim-wakatime";

  maintainers = [ maintainers.GaetanLepage ];
}
