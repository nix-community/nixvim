{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "zellij-nav";
  packPathName = "zellij-nav.nvim";
  package = "zellij-nav-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];
}
