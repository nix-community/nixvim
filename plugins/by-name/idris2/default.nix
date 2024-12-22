{
  helpers,
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "idris2";
  packPathName = "idris2";
  package = "idris2-nvim";
  maintainers = [ lib.maintainers.mitchmindtree ];
}
