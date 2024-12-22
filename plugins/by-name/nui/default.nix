{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "nui";
  packPathName = "nui.nvim";
  package = "nui-nvim";
  description = "UI Component Library for Neovim";
  maintainers = [ lib.maintainers.DataHearth ];

  callSetup = false;
  hasSettings = false;
}
