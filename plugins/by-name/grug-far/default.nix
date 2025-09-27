{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "grug-far";
  package = "grug-far-nvim";
  description = "Find And Replace plugin for Neovim.";

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
