{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "blink-pairs";
  moduleName = "blink.pairs";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    mappings.enabled = false;
    highlights = {
      enabled = true;
      cmdline = true;
      groups = [
        "rainbow1"
        "rainbow2"
        "rainbow3"
        "rainbow4"
        "rainbow5"
        "rainbow6"
      ];
      unmatched_group = "";
      matchparen = {
        enabled = true;
        cmdline = false;
        include_surrounding = false;
        group = "BlinkPairsMatchParen";
        priority = 250;
      };
    };
  };
}
