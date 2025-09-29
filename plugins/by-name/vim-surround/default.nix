{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "vim-surround";
  package = "vim-surround";
  description = "Delete/change/add parentheses/quotes/XML-tags/much more with ease.";

  maintainers = [ lib.maintainers.GaetanLepage ];
}
