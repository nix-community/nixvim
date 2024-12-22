{
  lib,
  ...
}:
lib.nixvim.plugins.mkVimPlugin {
  name = "numbertoggle";
  packPathName = "vim-numbertoggle";
  package = "vim-numbertoggle";

  maintainers = [ lib.maintainers.refaelsh ];
}
