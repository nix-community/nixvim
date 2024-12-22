{
  lib,
  ...
}:
lib.nixvim.plugins.mkVimPlugin {
  name = "repeat";
  packPathName = "vim-repeat";
  package = "vim-repeat";

  maintainers = [ lib.maintainers.refaelsh ];
}
