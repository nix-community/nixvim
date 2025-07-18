{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "kitty-scrollback";
  package = "kitty-scrollback-nvim";

  maintainers = [ lib.maintainers.nim65s ];
}
