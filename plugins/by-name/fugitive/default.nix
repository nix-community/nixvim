{
  lib,
  ...
}:
lib.nixvim.plugins.mkVimPlugin {
  name = "fugitive";
  package = "vim-fugitive";
  description = "Fugitive is the premier Vim plugin for Git management.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  dependencies = [ "git" ];

  # In typical tpope fashion, this plugin has no config options
}
