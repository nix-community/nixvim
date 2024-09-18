{
  lib,
  helpers,
  ...
}:
helpers.vim-plugin.mkVimPlugin {
  name = "vim-surround";
  originalName = "surround.vim";
  package = "vim-surround";

  maintainers = [ lib.maintainers.GaetanLepage ];
}
