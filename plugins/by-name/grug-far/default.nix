{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "grug-far";
  packPathName = "grug-far.nvim";
  package = "grug-far-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsExample = {
    debounceMs = 1000;
    minSearchChars = 1;
    maxSearchMatches = 2000;
    normalModeSearch = false;
    maxWorkers = 8;
    engine = "ripgrep";
    engines = {
      ripgrep = {
        path = "rg";
        showReplaceDiff = true;
      };
    };
  };
}
