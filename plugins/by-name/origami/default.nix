{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "origami";
  package = "nvim-origami";
  description = "A Neovim plugin for managing folds with ease.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    pauseFoldsOnSearch = true;
    setupFoldKeymaps = false;
  };
}
