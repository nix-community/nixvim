{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "ansiesc";
  package = "vim-plugin-AnsiEsc";

  maintainers = [ lib.maintainers.GaetanLepage ];
}
