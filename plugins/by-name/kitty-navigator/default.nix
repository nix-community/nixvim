{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "kitty-navigator";
  package = "vim-kitty-navigator";

  globalPrefix = "kitty_navigator_";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    enable_stack_layout = 1;
  };
}
