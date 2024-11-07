{
  lib,
  helpers,
  ...
}:
helpers.vim-plugin.mkVimPlugin {
  name = "helm";
  originalName = "vim-helm";
  package = "vim-helm";

  maintainers = [ lib.maintainers.GaetanLepage ];
}
