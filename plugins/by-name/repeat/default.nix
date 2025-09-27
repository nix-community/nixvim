{
  lib,
  ...
}:
lib.nixvim.plugins.mkVimPlugin {
  name = "repeat";
  package = "vim-repeat";
  description = "Enable repeating supported plugin maps with the '.' command.";

  maintainers = [ lib.maintainers.refaelsh ];
}
