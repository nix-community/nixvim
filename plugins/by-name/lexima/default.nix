{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "lexima";
  package = "lexima-vim";
  globalPrefix = "lexima_";
  description = "Auto close parentheses (and other pairs) by pressing \"dot\"s.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = import ./settings-options.nix lib;

  settingsExample = {
    map_escape = "";
    enable_space_rules = 0;
    enable_endwise_rules = 0;
  };
}
