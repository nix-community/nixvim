{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "origami";
  packPathName = "nvim-origami";
  package = "nvim-origami";
  description = "A Neovim plugin for managing folds with ease.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  # Ensures `nvim-ufo` (if enabled) is loaded before `origami`
  # Default priority is 1000, mkBefore is 500 and mkAfter is 1500
  configLocation = lib.mkOrder 1100 "extraConfigLua";

  settingsExample = {
    keepFoldsAcrossSessions = true;
    pauseFoldsOnSearch = true;
    setupFoldKeymaps = false;
  };
}
