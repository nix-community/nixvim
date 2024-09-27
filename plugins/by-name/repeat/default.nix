{
  lib,
  ...
}:
lib.nixvim.vim-plugin.mkVimPlugin {
  name = "repeat";
  originalName = "vim-repeat";
  package = "vim-repeat";

  maintainers = [ lib.maintainers.refaelsh ];
}
