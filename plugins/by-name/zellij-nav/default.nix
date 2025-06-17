{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "zellij-nav";
  packPathName = "zellij-nav.nvim";
  package = "zellij-nav-nvim";
  description = "Seamless navigation between Neovim windows and Zellij panes.";

  maintainers = [ lib.maintainers.GaetanLepage ];
}
