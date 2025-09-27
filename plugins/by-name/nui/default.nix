{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "nui";
  package = "nui-nvim";
  description = "UI Component Library for Neovim";
  maintainers = [ lib.maintainers.DataHearth ];

  callSetup = false;
  hasSettings = false;
}
