{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "ansiesc";
  package = "vim-plugin-AnsiEsc";
  description = "Vim plugin to conceal ANSI escape sequences in the text.";

  maintainers = [ lib.maintainers.GaetanLepage ];
}
