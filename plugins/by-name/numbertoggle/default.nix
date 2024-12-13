{
  lib,
  ...
}:
lib.nixvim.vim-plugin.mkVimPlugin {
  name = "numbertoggle";
  packPathName = "vim-numbertoggle";
  package = "vim-numbertoggle";

  maintainers = [ lib.maintainers.refaelsh ];
}
