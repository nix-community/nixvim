{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "lensline";
  packPathName = "lensline.nvim";
  package = "lensline-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsExample = {
    limits = {
      exclude_gitignored = false;
      max_lines = 500;
      max_lenses = 50;
    };
    debounce_ms = 250;
    focused_debounce_ms = 50;
  };
}
