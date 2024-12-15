{
  lib,
  ...
}:
lib.nixvim.vim-plugin.mkVimPlugin {
  name = "conjure";

  maintainers = [ lib.maintainers.GaetanLepage ];
}
