{ lib, ... }:
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "nui";
  originalName = "nui.nvim";
  package = "nui-nvim";
  description = "UI Component Library for Neovim";
  maintainers = [ lib.maintainers.DataHearth ];

  callSetup = false;
  hasSettings = false;
}
