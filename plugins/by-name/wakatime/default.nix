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
  description = "Vim plugin for WakaTime, a time tracking service for developers.";

  maintainers = [ maintainers.GaetanLepage ];
}
