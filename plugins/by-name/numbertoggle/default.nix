{
  lib,
  ...
}:
lib.nixvim.vim-plugin.mkVimPlugin {
  name = "numbertoggle";
  originalName = "vim-numbertoggle";
  package = "vim-numbertoggle";

  maintainers = [ lib.maintainers.refaelsh ];
}
