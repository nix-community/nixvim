{
  lib,
  helpers,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "smart-splits";
  packPathName = "smart-splits.nvim";
  package = "smart-splits-nvim";

  maintainers = [ lib.maintainers.foo-dogsquared ];

  settingsExample = {
    resize_mode = {
      quit_key = "<ESC>";
      resize_keys = [
        "h"
        "j"
        "k"
        "l"
      ];
      silent = true;
    };
    ignored_events = [
      "BufEnter"
      "WinEnter"
    ];
  };
}
