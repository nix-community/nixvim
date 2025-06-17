{
  lib,
  ...
}:
lib.nixvim.plugins.mkVimPlugin {
  name = "numbertoggle";
  packPathName = "vim-numbertoggle";
  package = "vim-numbertoggle";
  description = "Toggles between hybrid and absolute line numbers automatically.";

  maintainers = [ lib.maintainers.refaelsh ];
}
