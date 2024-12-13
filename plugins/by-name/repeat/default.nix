{
  lib,
  ...
}:
lib.nixvim.vim-plugin.mkVimPlugin {
  name = "repeat";
  packPathName = "vim-repeat";
  package = "vim-repeat";

  maintainers = [ lib.maintainers.refaelsh ];
}
