{
  lib,
  helpers,
  ...
}:
lib.nixvim.vim-plugin.mkVimPlugin {
  name = "commentary";
  packPathName = "vim-commentary";
  package = "vim-commentary";

  # TODO Add support for additional filetypes. This requires autocommands!

  maintainers = [ lib.maintainers.GaetanLepage ];

  # This plugin has no config options
}
