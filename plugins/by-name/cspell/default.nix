{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "cspell";
  package = "cspell-nvim";
  description = "cspell diagnostics and code actions for none-ls.";

  maintainers = [ lib.maintainers.khaneliman ];

  dependencies = [
    "cspell"
  ];

  callSetup = false;
  hasSettings = false;
}
