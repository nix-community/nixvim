{
  lib,
  helpers,
  ...
}:
helpers.vim-plugin.mkVimPlugin {
  name = "nix";
  originalName = "vim-nix";
  package = "vim-nix";

  maintainers = [ lib.maintainers.GaetanLepage ];
}
