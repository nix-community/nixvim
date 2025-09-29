{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "commentary";
  package = "vim-commentary";
  description = "Comment stuff out.";

  # TODO Add support for additional filetypes. This requires autocommands!

  maintainers = [ lib.maintainers.GaetanLepage ];

  # This plugin has no config options
}
