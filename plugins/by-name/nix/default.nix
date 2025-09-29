{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "nix";
  package = "vim-nix";
  description = "Syntax highlighting and indenting for the Nix expression language.";

  maintainers = [ lib.maintainers.GaetanLepage ];
}
