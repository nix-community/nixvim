{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "abolish";
  package = "vim-abolish";

  maintainers = [ lib.maintainers.Fovir ];
}
