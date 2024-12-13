{
  lib,
  helpers,
  ...
}:
helpers.vim-plugin.mkVimPlugin {
  name = "nix";
  packPathName = "vim-nix";
  package = "vim-nix";

  maintainers = [ lib.maintainers.GaetanLepage ];
}
