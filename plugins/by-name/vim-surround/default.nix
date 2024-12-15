{
  lib,
  helpers,
  ...
}:
lib.nixvim.vim-plugin.mkVimPlugin {
  name = "vim-surround";
  packPathName = "surround.vim";
  package = "vim-surround";

  maintainers = [ lib.maintainers.GaetanLepage ];
}
