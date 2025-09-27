{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "devdocs";
  package = "devdocs-nvim";
  description = "A Neovim plugin for accessing DevDocs documentation.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    ensure_installed = [
      "go"
      "html"
      "http"
      "lua~5.1"
    ];
  };
}
