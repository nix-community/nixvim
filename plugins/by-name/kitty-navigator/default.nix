{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "kitty-navigator";
  package = "vim-kitty-navigator";
  globalPrefix = "kitty_navigator_";
  description = "Seamless navigation between kitty panes and vim splits.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    enable_stack_layout = 1;
  };
}
