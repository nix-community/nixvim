{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "lexima";
  packPathName = "lexima.vim";
  package = "lexima-vim";
  globalPrefix = "lexima_";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = import ./settings-options.nix lib;

  settingsExample = {
    map_escape = "";
    enable_space_rules = 0;
    enable_endwise_rules = 0;
  };
}
