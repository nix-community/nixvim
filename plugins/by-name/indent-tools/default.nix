{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "indent-tools";
  packPathName = "indent-tools.nvim";
  package = "indent-tools-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    textobj = {
      ii = "iI";
      ai = "aI";
    };
    normal = {
      up = false;
      down = false;
    };
  };
}
