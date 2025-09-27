{
  lib,
  helpers,
  ...
}:
lib.nixvim.plugins.mkVimPlugin {
  name = "endwise";
  package = "vim-endwise";
  description = "A Vim plugin that automatically adds `end` to Ruby blocks.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  # This plugin has no config options
}
