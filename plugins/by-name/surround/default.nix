{
  lib,
  helpers,
  ...
}:
helpers.vim-plugin.mkVimPlugin {
  name = "surround";
  originalName = "surround.vim";
  package = "vim-surround";

  maintainers = [ lib.maintainers.GaetanLepage ];
}
