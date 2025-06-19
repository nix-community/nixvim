{
  helpers,
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "idris2";
  packPathName = "idris2";
  package = "idris2-nvim";
  description = "Idris2 support for Neovim.";
  maintainers = [ lib.maintainers.mitchmindtree ];
}
