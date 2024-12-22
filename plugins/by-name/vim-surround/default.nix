{
  lib,
  helpers,
  ...
}:
lib.nixvim.plugins.mkVimPlugin {
  name = "vim-surround";
  packPathName = "surround.vim";
  package = "vim-surround";

  maintainers = [ lib.maintainers.GaetanLepage ];
}
