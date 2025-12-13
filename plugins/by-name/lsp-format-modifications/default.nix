{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "lsp-format-modifications";
  package = "lsp-format-modifications-nvim";
  callSetup = false;

  maintainers = [ lib.maintainers.shved ];
  url = "https://github.com/joechrisellis/lsp-format-modifications.nvim";
  description = "LSP formatting, but only on modified text regions.";
}
