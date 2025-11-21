{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "tiny-glimmer";
  package = "tiny-glimmer-nvim";

  maintainers = [ lib.maintainers.arne-zillhardt ];

  settingsExample = {
    refresh_interval_ms = 5;
    overwrite = {
      yank.default_animation = "rainbow";
      paste.enabled = false;
    };
    animations = {
      pulse = {
        max_duration = 400;
        min_duration = 200;
        chars_for_max_duration = 10;
      };
      rainbow.chars_for_max_duration = 10;
    };
  };
}
