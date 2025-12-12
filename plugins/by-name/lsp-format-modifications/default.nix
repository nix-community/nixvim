{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "lsp-format-modifications";
  package = "lsp-format-modifications-nvim";
  callSetup = false;
  hasSettings = false;

  maintainers = [ lib.maintainers.shved ];
  description = "LSP formatting, but only on modified text regions.";
}
