{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "wakatime";
  package = "vim-wakatime";
  description = "Vim plugin for WakaTime, a time tracking service for developers.";

  maintainers = [ lib.maintainers.GaetanLepage ];
}
