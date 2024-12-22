{
  lib,
  helpers,
  ...
}:
lib.nixvim.plugins.mkVimPlugin {
  name = "nix";
  packPathName = "vim-nix";
  package = "vim-nix";

  maintainers = [ lib.maintainers.GaetanLepage ];
}
