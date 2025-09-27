{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "nvim-bqf";
  description = "Better quickfix window in Neovim, polish old quickfix window.";
  moduleName = "bqf";
  maintainers = [ ];

  # TODO: introduced 2025-09-27: remove after 26.05
  inherit (import ./deprecations.nix lib) deprecateExtraOptions optionsRenamedToSettings;

  settingsExample = {
    preview = {
      winblend = 0;
      show_title = false;
      border = "double";
      show_scroll_bar = false;
    };
  };
}
