{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "devdocs";
  packPathName = "devdocs.nvim";
  package = "devdocs-nvim";

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
