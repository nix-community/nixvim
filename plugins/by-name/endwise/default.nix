{
  lib,
  helpers,
  ...
}:
lib.nixvim.vim-plugin.mkVimPlugin {
  name = "endwise";
  packPathName = "vim-endwise";
  package = "vim-endwise";

  maintainers = [ lib.maintainers.GaetanLepage ];

  # This plugin has no config options
}
