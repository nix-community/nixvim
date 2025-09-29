{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "preview";
  package = "Preview-nvim";
  description = "Neovim wrapper around MD-TUI.";

  hasSettings = false;

  maintainers = [ lib.maintainers.GaetanLepage ];
}
