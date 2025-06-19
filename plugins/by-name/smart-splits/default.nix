{
  lib,
  helpers,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "smart-splits";
  packPathName = "smart-splits.nvim";
  package = "smart-splits-nvim";
  description = "Smarter and more intuitive split pane management that uses a mental model of left/right/up/down instead of wider/narrower/taller/shorter for resizing splits.";

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
